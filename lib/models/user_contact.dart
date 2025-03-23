import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

class UserContact {
  final Color color;
  Contact contact;
  int? customerId;
  bool isCustomer = false;

  UserContact({
    required this.color,
    required this.contact,
    required this.customerId,
    this.isCustomer = false,
  });
}
