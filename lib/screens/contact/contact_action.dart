import 'dart:async';

import 'package:base/config/view_actions.dart';
import 'package:base/models/customer.dart';
import 'package:base/models/user_contact.dart';
import 'package:base/service/customer_service.dart';
import 'package:base/utils/dialog_util.dart';
import 'package:base/utils/perrmission_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ContactAction extends ViewActions {
  RxList<UserContact> contacts = <UserContact>[].obs;
  RxList<UserContact> filteredContacts = <UserContact>[].obs;
  List<UserContact> contactsFiltered = [];

  List<Customer> customers = <Customer>[].obs;

  RxBool contactsLoaded = false.obs;
  Timer? _debounce;

  final CustomerService _customerService = CustomerService();

  Rxn<TextEditingController> searchController = Rxn(TextEditingController());

  @override
  initState() {
    loadData();
    searchController.value?.addListener(_onSearchChanged);
  }

  Future<void> loadData() async {
    await fetchCustomers();
    await fetchContacts();
    contactsLoaded.value = true;
  }

  /// Fetches contacts from the device and assigns them to the `contacts` list.
  ///
  /// This function checks for contact permissions and, if granted, retrieves
  /// the contacts from the device using `FlutterContacts.getContacts`. Each
  /// contact is assigned a color from a predefined list of colors, cycling
  /// through the list. It also checks if the contact's phone number matches
  /// any customer in the `customers` list and marks the contact as a customer
  /// if a match is found.
  ///
  /// If the contact permissions are not granted, an alert dialog is shown
  /// prompting the user to grant the permissions, and the function is called
  /// again.
  ///
  /// Throws:
  /// - `Exception` if there is an error fetching the contacts.
  Future<void> fetchContacts() async {
    List colors = [Colors.green, Colors.indigo, Colors.yellow, Colors.orange];
    int colorIndex = 0;
    if (await PermissionUtil.checkContactPermissions()) {
      List<UserContact> fetchedContacts =
          (await FlutterContacts.getContacts(withProperties: true))
              .map((contact) {
        Color baseColor = colors[colorIndex];
        colorIndex++;
        if (colorIndex == colors.length) {
          colorIndex = 0;
        }

        // Check if contact phone number is in the list of customers
        bool isCustomer = false;
        int? customerId;
        for (var customer in customers) {
          if (customer.phone == contact.phones.first.number) {
            isCustomer = true;
            customerId = customer.id;
            break;
          }
        }

        return UserContact(
          contact: contact,
          color: baseColor,
          isCustomer: isCustomer,
          customerId: customerId,
        );
      }).toList();
      contacts.assignAll(fetchedContacts);
      filteredContacts.assignAll(fetchedContacts);
    } else {
      DialogUtil.alertDialog(
          "Vui lòng cấp quyền truy cập danh bạ để sử dụng chức năng này");
      fetchContacts();
    }
  }

  /// Load list of customers
  /// @return void
  Future<void> fetchCustomers() async {
    customers = (await _customerService.getCustomersPhones()).cast<Customer>();
  }

  /// Handles the search input changes with a debounce mechanism to limit the
  /// frequency of search operations. If the debounce timer is active, it cancels
  /// the previous timer and sets a new one with a delay of 500 milliseconds.
  /// After the delay, it triggers the `searchContact` function with the current
  /// text in the search controller.
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchContact(searchController.value?.text ?? '');
    });
  }

  void searchContact(String keyword) {
    print(keyword);
    if (keyword.isEmpty) {
      filteredContacts.assignAll(contacts);
    } else {
      filteredContacts.value = contacts.where((contact) {
        return contact.contact.displayName
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            contact.contact.phones.first.number.contains(keyword);
      }).toList();
    }
  }
}
