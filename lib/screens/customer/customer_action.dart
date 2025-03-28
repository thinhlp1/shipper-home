// ignore_for_file: avoid_print

import 'dart:async';

import 'package:base/config/view_actions.dart';
import 'package:base/models/customer.dart';
import 'package:base/service/customer_service.dart';
import 'package:base/service/database_service.dart';
import 'package:base/third_service/google_map_service.dart';
import 'package:base/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerAction extends ViewActions {
  RxList<Customer> customers = <Customer>[].obs;
  RxList<Customer> filteredCustomer = <Customer>[].obs;

  Rxn<TextEditingController> searchController = Rxn(TextEditingController());
  final CustomerService _customerService = CustomerService();
  final DatabaseService _databaseService = DatabaseService.instance;

  Timer? _debounce;
  final ScrollController scrollController = ScrollController();

  @override
  initState() {
    loadData();
    searchController.value?.addListener(_onSearchChanged);
  }

  Future<void> loadData() async {
    await fetchCustomers();
  }

  /// Load list of customers
  /// @return void
  Future<void> fetchCustomers() async {
    customers.value = (await _customerService.getCustomers()).cast<Customer>();
    filteredCustomer.assignAll(customers);
  }

  /// Load the last customer added
  /// @return void
  void addCustomerLastInsert() async {
    customers.insert(0, (await _customerService.getCustomers()).first);
  }

  /// Updates the favorite status of a customer.
  ///
  /// This method calls the `_customerService.updateIsFavorite` function to
  /// update the favorite status of a customer identified by the given `id`.
  /// Update ui and sorts the list of customers after the update.
  ///
  ///
  /// - Parameters:
  ///   - id: The unique identifier of the customer.
  ///   - isFavorite: A boolean value indicating whether the customer is a favorite.
  void updateIsFavorite(int id, bool isFavorite) {
    // Function to update the favorite status in a list
    void updateFavoriteStatus(RxList<Customer> customerss) {
      final index = customerss.indexWhere((element) => element.id == id);
      if (index != -1) {
        customerss[index].isFavorite = isFavorite;
        customerss.refresh(); // Notify the UI to update
      }
    }

    // Find the index of the last favorite customer and the current customer
    int lastFavoriteIndex =
        customers.lastIndexWhere((customer) => customer.isFavorite) + 1;

    final currentIndex = customers.indexWhere((element) => element.id == id);

    // this adjustment is needed when moving down the list
    if (currentIndex < lastFavoriteIndex) {
      lastFavoriteIndex -= 1;
    }
    // Update favorite status in original and filtered lists
    updateFavoriteStatus(filteredCustomer);
    updateFavoriteStatus(customers);

    // Update database
    _customerService.updateIsFavorite(id, isFavorite);

    // remove the tile from the old position
    final Customer customer = customers.removeAt(currentIndex);
    // place the tile in new position
    customers.insert(lastFavoriteIndex, customer);

    // Reorder the list after moving favorites to the beginning
    // Update positions in the list
    for (int i = 0; i < customers.length; i++) {
      customers[i].position = i + 1;
    }

    // If list not filtered, update the filtered list
    if (filteredCustomer.length == customers.length) {
      filteredCustomer.assignAll(customers);
    }

    // Update positions in the database
    _customerService.updateCustomerPositions(customers);
    SnackbarUtil.showFavoriteSnackbar('Thành công',
        isFavorite ? 'Đã đánh dấu là quan trọng' : 'Đã bỏ quan trọng');
  }

  /// Reorders the list of customers by moving a customer from the old index to the new index.
  ///
  /// If the customer is moved down the list, the new index is adjusted accordingly.
  /// After reordering, the positions of the customers in the list are updated and
  /// the changes are reflected in the database.
  ///
  /// If the list is filtered, the function reorders the filtered list without saving the position.
  ///
  /// - Parameters:
  ///  - oldIndex: The original index of the customer in the list.
  /// - newIndex: The new index of the customer in the list.
  void reorderCustomer(int oldIndex, int newIndex) {
    // this adjustment is needed when moving down the list
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // If the list is filtered, reorder without saving the position
    if (filteredCustomer.length != customers.length) {
      SnackbarUtil.showWarningSnackbar(
          'Không thể sắp xếp', 'Hủy bộ lọc để sắp xếp');
      return;
    }

    // get the tile we are moving
    final Customer customer = customers.removeAt(oldIndex);
    // place the tile in new position
    customers.insert(newIndex, customer);

    // Move isFavorite customers to the beginning of the list
    final favoriteCustomers =
        customers.where((customer) => customer.isFavorite).toList();
    final nonFavoriteCustomers =
        customers.where((customer) => !customer.isFavorite).toList();
    customers
      ..clear()
      ..addAll(favoriteCustomers)
      ..addAll(nonFavoriteCustomers);

    // Update positions in the list
    for (int i = 0; i < customers.length; i++) {
      customers[i].position = i + 1;
    }

    filteredCustomer.assignAll(customers);

    // Update positions in the database
    _customerService.updateCustomerPositions(customers);
  }

  void ordercustomers() {
    // Update positions in the list
    for (int i = 0; i < customers.length; i++) {
      customers[i].position = i + 1;
    }

    // Update positions in the database
    _customerService.updateCustomerPositions(customers);
  }

  /// Reset the database
  /// @return void
  void resetDatabase() {
    _databaseService.resetDatabase();
  }

  /// Searches for customers based on the provided keyword.
  ///
  /// If the keyword is empty, the function resets the filtered customer list to the original list.
  /// Otherwise, it filters the customer list to include only those customers whose name, phone,
  /// or address contains the keyword.
  ///
  /// Parameters:
  /// - keyword: The search keyword to filter the customers.
  void searchCustomer(String keyword) {
    if (keyword.isEmpty) {
      filteredCustomer.assignAll(customers);
    } else {
      filteredCustomer.value = customers.where((customer) {
        return customer.name!.toLowerCase().contains(keyword.toLowerCase()) ||
            customer.phone.contains(keyword) ||
            customer.address.toLowerCase().contains(keyword.toLowerCase());
      }).toList();
    }
  }

  /// Handles the search input changes with a debounce mechanism to limit the
  /// frequency of search operations. If the debounce timer is active, it cancels
  /// the previous timer and sets a new one with a delay of 500 milliseconds.
  /// After the delay, it triggers the `searchCustomer` function with the current
  /// text in the search controller.
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchCustomer(searchController.value?.text ?? '');
    });
  }

  /// Deletes a customer from the database and the list of customers.
  ///
  /// Parameters:
  /// - id: The unique identifier of the customer to be deleted.
  void deleteCustomer(int id) {
    _customerService.deleteCustomer(id);
    customers.removeWhere((element) => element.id == id);
    filteredCustomer.removeWhere((element) => element.id == id);

    Get.back();
    SnackbarUtil.showSuccessSnackbar('Thành công', 'Xóa thành công');
  }

  /// Opens Google Maps at the specified latitude and longitude.
  ///
  /// This function constructs a URL to open Google Maps with the given
  /// coordinates. If the URL can be launched, it will open Google Maps
  /// at the specified location. If the URL cannot be launched, it will
  /// display an alert dialog with an error message.
  ///
  /// Parameters:
  /// - mapPosition: The latitude and longitude of the location to open in Google Maps.
  Future<void> openGoogleMaps(String mapPosition) async {
    if (mapPosition != '') {
      List<String> coordinates = mapPosition.split(',');
      double latitude = double.parse(coordinates[0].trim());
      double longitude = double.parse(coordinates[1].trim());
      await GoogleMapService.openGoogleMaps(
        latitude,
        longitude,
      );
    }
  }

  /// Scrolls to the end of the list of customers.
  void scrollToTheEnd() {
    // Chờ giao diện cập nhật rồi scroll xuống cuối danh sách
    Future.delayed(const Duration(milliseconds: 1000), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void callCustomer(int id) {
    print("Call customer with id: $id");
    final customer = customers.firstWhere((element) => element.id == id);
    print("Call to: ${customer.phone}");
  }

  void openCart() {
    print("Navigator to cart");
  }
}
