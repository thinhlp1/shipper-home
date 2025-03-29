import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingUtil {
  /// Displays a loading dialog with a circular progress indicator.
  ///
  /// The dialog is centered on the screen and cannot be dismissed by tapping
  /// outside of it (barrierDismissible is set to false).
  ///
  /// This function uses the `Get.dialog` method from the GetX package to show
  /// the loading dialog.
  static void showLoading() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }

  /// Hides the loading dialog if it is currently open.
  ///
  /// This function checks if a dialog is open using `Get.isDialogOpen`.
  /// If a dialog is open, it closes the dialog by calling `Get.back()`.
  static void hideLoading() {
    if (Get.isDialogOpen == true) {
      print('Dialog is open, closing it...');
      Get.back();
    }
  }
}
