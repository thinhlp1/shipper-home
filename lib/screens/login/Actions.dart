import 'package:base/api/Client.dart';
import 'package:base/config/ViewActions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/text_field_validation.dart';

class LoginActions extends ViewActions {
  final Client _client;
  LoginActions(this._client);

  Rx<bool> isCheck = Rx(false);
  GlobalKey<FormState> formLogin = GlobalKey<FormState>();

  // Rxn<TextEditingController> phoneNumber = Rxn(TextEditingController());

  final phoneNumber = TextEditingController();

  void isChecked() {
    isCheck.value = !isCheck.value;
  }

  void submitForm() {}

// check phone number
  String? validatePhoneNumber(String? value) {
    String? mess;

    // check value empty
    mess = TextFieldValidation.isEmpty(
        value: value, errorText: 'Vui lòng nhập số điện thoại');

    if (mess != null) {
      return mess;
    }

    // check value is phone number
    mess = TextFieldValidation.isPhoneNumber(
        value: value, errorText: 'Số điện thoại bạn nhập không hợp lệ');

    return mess;
  }
}
