import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarUtil {
  /// Shows a success snackbar with the given [title] and [message].
  static void showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.check_circle, color: Colors.green),
      colorText: Colors.green.shade700,
      duration: const Duration(milliseconds: 1500),
    );
  }

  /// Shows an error snackbar with the given [title] and [message].
  static void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.error, color: Colors.red),
      colorText: Colors.red.shade700,
      duration: const Duration(milliseconds: 1500),
    );
  }

  /// Shows a warning snackbar with the given [title] and [message].
  static void showWarningSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.warning, color: Colors.orange),
      colorText: Colors.orange.shade700,
      duration: const Duration(milliseconds: 1500),
    );
  }

  /// Shows an info snackbar with the given [title] and [message].
  static void showInfoSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.info, color: Colors.blue),
      colorText: Colors.blue.shade700,
      duration: const Duration(milliseconds: 1500),
    );
  }

  /// Shows a favorite snackbar with the given [title] and [message].
  static void showFavoriteSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.favorite, color: Colors.pink),
      colorText: Colors.pink.shade700,
      duration: const Duration(milliseconds: 1500),
    );
  }
}
