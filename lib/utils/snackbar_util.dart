import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarUtil {
  /// Shows a success snackbar with the given [title] and [message].
  static void showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(Icons.check_circle, color: Colors.green),
      backgroundColor: Colors.white,
      borderColor: Colors.green,
      borderWidth: 1.0,
      colorText: Colors.green,
      duration: const Duration(microseconds: 1500),
      margin: const EdgeInsets.all(8.0),
    );
  }

  /// Shows an error snackbar with the given [title] and [message].
  static void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(Icons.error, color: Colors.red),
      backgroundColor: Colors.white,
      borderColor: Colors.red,
      borderWidth: 1.0,
      colorText: Colors.red,
      duration: const Duration(microseconds: 1500),
      margin: const EdgeInsets.all(8.0),
    );
  }

  /// Shows a warning snackbar with the given [title] and [message].
  static void showWarningSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(Icons.warning, color: Colors.orange),
      backgroundColor: Colors.white,
      borderColor: Colors.orange,
      borderWidth: 1.0,
      duration: const Duration(microseconds: 1500),
      margin: const EdgeInsets.all(8.0),
    );
  }
}
