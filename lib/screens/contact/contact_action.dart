import 'package:base/config/view_actions.dart';
import 'package:base/utils/dialog_util.dart';
import 'package:base/utils/perrmission_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ContactAction extends ViewActions {
  List<Contact> contacts = <Contact>[].obs;
  List<Contact> filteredContacts = <Contact>[].obs;

  Rxn<TextEditingController> searchController = Rxn(TextEditingController());

  @override
  initState() {
    loadData();
  }

  Future<void> loadData() async {
    await fetchContacts();
  }

  Future<void> fetchContacts() async {
    if (await PermissionUtil.checkContactPermissions()) {
      final List<Contact> fetchedContacts = await FlutterContacts.getContacts(withProperties: true);
      contacts.assignAll(fetchedContacts);
    } else {
      DialogUtil.alertDialog(
          "Vui lòng cấp quyền truy cập danh bạ để sử dụng chức năng này");
    }
  }
}
