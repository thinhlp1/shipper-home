import 'package:base/api/Client.dart';
import 'package:base/config/Injection.dart';
import 'package:base/config/ViewWidget.dart';
import 'package:base/screens/login/Actions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ViewWidget<LoginScreen, LoginActions> {
  final bool _isChecked = false;
  String phoneNumber = "";
  @override
  Widget render(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo.png",
                    width: 200,
                    height: 80,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Xác thực số điện thoại",
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Vui lòng xác nhận số điện thoại của bạn để đăng ký tài khoản với LT Food",
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: SizedBox(
                      width: double.infinity,
                      child: Form(
                        key: viewActions.formLogin,
                        child: TextFormField(
                          controller: viewActions.phoneNumber,
                          decoration: InputDecoration(
                            hintText: "Nhập số điện thoại",
                            border:
                                Theme.of(context).inputDecorationTheme.border,
                          ),
                          validator: viewActions.validatePhoneNumber,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CheckboxListTile(
                  title: Text(
                      "Tôi đồng ý về Điều khoản sử dụng dịch vụ & Chính sách bảo mật của LT Food",
                      style: Theme.of(context).textTheme.bodyMedium),
                  value: viewActions.isCheck.obs().value,
                  onChanged: (value) {
                    viewActions.isChecked();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: viewActions.isCheck.obs().value
                        ? viewActions.submitForm
                        : null,
                    child: const Text(
                      "Tiếp theo",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  LoginActions createViewActions() => LoginActions(getIt<Client>());
}
