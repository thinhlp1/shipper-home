import 'package:base/config/view_actions.dart';
import 'package:base/screens/contact/contact_view.dart';
import 'package:base/screens/customer/customer_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainActions extends ViewActions {
  List<Widget> views = <Widget>[
    const CustomerScreen(),
    const ContactScreen(),
  ];
}
