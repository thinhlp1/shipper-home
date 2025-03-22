import 'package:base/config/view_actions.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactAction extends ViewActions {

  List<Contact> contacts = <Contact>[].obs;

  Rxn<TextEditingController> searchController = Rxn(TextEditingController());
}
