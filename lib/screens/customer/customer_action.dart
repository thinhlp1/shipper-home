// ignore_for_file: avoid_print

import 'dart:async';

import 'package:base/config/view_actions.dart';
import 'package:base/models/customer.dart';
import 'package:base/service/customer_service.dart';
import 'package:base/service/database_service.dart';
import 'package:base/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerAction extends ViewActions {
  RxList<Customer> listCustomer = <Customer>[].obs;
  RxList<Customer> filteredCustomer = <Customer>[].obs;

  Rxn<TextEditingController> searchController = Rxn(TextEditingController());
  final CustomerService _customerService = CustomerService();
  final DatabaseService _databaseService = DatabaseService.instance;
  Timer? _debounce;

  @override
  initState() {
    loadData();
    searchController.value?.addListener(_onSearchChanged);
  }

  Future<void> loadData() async {
    await loadListContacts();
  }

  /// Load list of customers
  /// @return void
  Future<void> loadListContacts() async {
    listCustomer.value =
        (await _customerService.getCustomers()).cast<Customer>();
    filteredCustomer.assignAll(listCustomer);
  }

  /// Load the last customer added
  /// @return void
  void addCustomerLastInsert() async {
    listCustomer.insert(0, (await _customerService.getCustomers()).first);
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
    void updateFavoriteStatus(RxList<Customer> customers) {
      final index = customers.indexWhere((element) => element.id == id);
      if (index != -1) {
        customers[index].isFavorite = isFavorite;
        customers.refresh(); // Notify the UI to update
      }
    }

    // Update favorite status in original and filtered lists
    updateFavoriteStatus(filteredCustomer);
    updateFavoriteStatus(listCustomer);

    // Update database
    _customerService.updateIsFavorite(id, isFavorite);
  }

  /// Reorders the list of customers by moving a customer from the old index to the new index.
  ///
  /// If the customer is moved down the list, the new index is adjusted accordingly.
  /// After reordering, the positions of the customers in the list are updated and
  /// the changes are reflected in the database.
  ///
  /// If the list is filtered, the function reorders the filtered list without saving the position.
  ///
  /// @param oldIndex The current index of the customer to be moved.
  /// @param newIndex The target index where the customer should be moved.
  /// @return void
  void reorderCustomer(int oldIndex, int newIndex) {
    // this adjustment is needed when moving down the list
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // If the list is filtered, reorder without saving the position
    if (filteredCustomer.length != listCustomer.length) {
      SnackbarUtil.showWarningSnackbar(
          'Không thể sắp xếp', 'Hủy bộ lọc để sắp xếp');
      return;
    }

    // get the tile we are moving
    final Customer customer = listCustomer.removeAt(oldIndex);
    // place the tile in new position
    listCustomer.insert(newIndex, customer);

    // Move isFavorite customers to the beginning of the list
    final favoriteCustomers =
        listCustomer.where((customer) => customer.isFavorite).toList();
    final nonFavoriteCustomers =
        listCustomer.where((customer) => !customer.isFavorite).toList();
    listCustomer
      ..clear()
      ..addAll(favoriteCustomers)
      ..addAll(nonFavoriteCustomers);

    // Update positions in the list
    for (int i = 0; i < listCustomer.length; i++) {
      listCustomer[i].position = i + 1;
    }

    filteredCustomer.assignAll(listCustomer);

    // Update positions in the database
    _customerService.updateCustomerPositions(listCustomer);
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
  /// - Parameter keyword: The search keyword used to filter the customer list.
  void searchCustomer(String keyword) {
    if (keyword.isEmpty) {
      filteredCustomer.assignAll(listCustomer);
    } else {
      filteredCustomer.value = listCustomer.where((customer) {
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
    listCustomer.removeWhere((element) => element.id == id);
    filteredCustomer.removeWhere((element) => element.id == id);

    Get.back();
    SnackbarUtil.showSuccessSnackbar('Thành công', 'Xóa thành công');
  }

  void callCustomer(int id) {
    print("Call customer with id: $id");
    final customer = listCustomer.firstWhere((element) => element.id == id);
    print("Call to: ${customer.phone}");
  }

  void openCart() {
    print("Navigator to cart");
  }
}
