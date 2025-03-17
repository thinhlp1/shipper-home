import 'package:base/config/ViewActions.dart';
import 'package:base/screens/main/View.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashActions extends ViewActions {
  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      Navigator.pushReplacement(Get.context!,
          MaterialPageRoute(builder: (context) => const MainScreen()));
    });
  }
}
