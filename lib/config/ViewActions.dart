import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class ViewActions{
  initState() {}

  dispose() {}

  GlobalKey<NavigatorState> keyLoading = GlobalKey<NavigatorState>();

  @protected
  Future<T?> loading<T>(
    Future<T> Function() future, {
    Widget? dialog,
    bool showErrorDialog = true,
    bool reCatchString = false,
  }) async {
    bool showDialog = false;
    T? result;
    try {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showDialog = true;
        Get.dialog(
          dialog ??
              Scaffold(
                key: keyLoading,
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(Get.context!).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
          barrierDismissible: false,
          name: 'dialog_showing',
        );
      });
      result = await future();
    } on DioException catch (error) {
      if (error.response?.statusCode == HttpStatus.unauthorized) {
        rethrow;
      }

      if (showErrorDialog) {
        String? message = error.message;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if ((Get.isDialogOpen ?? false) && showDialog) {
            showDialog = false;
            Get.back();
          }
          showAlertDialog(message ?? "Đã có lỗi xảy ra 1");
        });
      }
      rethrow;
    } on String catch (value) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if ((Get.isDialogOpen ?? false) && showDialog) {
          showDialog = false;
          Get.back();
        }
        showAlertDialog(value);
      });
      if (reCatchString) {
        rethrow;
      }
    } finally {
      if ((Get.isDialogOpen ?? false) && showDialog) {
        showDialog = false;
        if (Get.isSnackbarOpen) {
          Get.closeAllSnackbars();
        }
        Get.back();
      }
    }
    return result;
  }

  Future<void> showAlertDialog(String messageDialog) {
    // TODO: Show error
    return Get.dialog(AlertDialog(
      title: const Text('Cảnh báo'),
      content: Text(messageDialog),
      actions: [
        ElevatedButton(onPressed: Get.back, child: const Text('Xác nhận')),
      ],
    ));
  }
}
