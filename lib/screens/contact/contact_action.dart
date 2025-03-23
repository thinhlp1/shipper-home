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
  List<UserContact> contacts = <UserContact>[].obs;
  List<UserContact> filteredContacts = <UserContact>[].obs;
  List<UserContact> contactsFiltered = [];

  List<Customer> customers = <Customer>[].obs;

  Map<String, Color> contactsColorMap = new Map();
  bool contactsLoaded = false;

  final CustomerService _customerService = CustomerService();

  Rxn<TextEditingController> searchController = Rxn(TextEditingController());

  @override
  initState() {
    loadData();
  }

  Future<void> loadData() async {
    await fetchCustomers();
    await fetchContacts();
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
    } else {
      DialogUtil.alertDialog(
          "Vui lòng cấp quyền truy cập danh bạ để sử dụng chức năng này");
      fetchContacts();
    }
  }

  /// Load list of customers
  /// @return void
  Future<void> fetchCustomers() async {
    customers = (await _customerService.getCustomers()).cast<Customer>();
  }
}
