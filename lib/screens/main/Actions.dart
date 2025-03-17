import 'package:base/config/ViewActions.dart';
import 'package:base/screens/customer/customer_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainActions extends ViewActions {
  List<Widget> views = <Widget>[
    const CustomerScreen(),
    const CustomerScreen(),
    const CustomerScreen(),
  ];
}
