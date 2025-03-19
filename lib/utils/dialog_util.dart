import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogUtil {
  /// Displays an alert dialog with a given message.
  ///
  /// The dialog contains a title "Cảnh báo" (Warning) and a confirmation button labeled "Xác nhận" (Confirm).
  ///
  /// The dialog is displayed using the GetX package's `Get.dialog` method.
  ///
  /// Parameters:
  /// - `message`: The message to be displayed in the content of the alert dialog.
  static alertDialog(String message) {
    Get.dialog(AlertDialog(
      title: const Text('Cảnh báo'),
      content: Text(message),
      actions: [
        ElevatedButton(onPressed: Get.back, child: const Text('Xác nhận')),
      ],
    ));
  }
}
