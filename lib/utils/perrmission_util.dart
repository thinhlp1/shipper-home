import 'package:base/utils/hex_color.dart';
import 'package:base/utils/theme_color.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class PermissionUtil {
  /// Checks storage permissions for the application.
  ///
  /// This function first checks if the platform is Android and if the Android version
  /// meets the required criteria. If both conditions are met, it returns `true`.
  ///
  /// If the platform is not Android or the Android version check fails, it then checks
  /// the current storage permission status. If the storage permission is granted, it
  /// returns `true`. Otherwise, it requests storage permissions and returns the result
  /// of that request.
  ///
  /// Returns a [Future] that completes with `true` if storage permissions are granted,
  /// and `false` otherwise.
  static Future<bool> checkStoragePermissions() async {
    if (Platform.isAndroid && await checkAndroidVersion()) {
      return true;
    }

    PermissionStatus storageStatus = await Permission.storage.status;
    if (storageStatus.isGranted) {
      return true;
    } else {
      return await requestStoragePermissions();
    }
  }

  /// Checks the current camera permissions status.
  ///
  /// If the camera permission is already granted, it returns `true`.
  /// Otherwise, it requests the camera permission and returns the result.
  ///
  /// Returns a [Future] that completes with `true` if the camera permission
  /// is granted, and `false` otherwise.
  static Future<bool> checkCameraPermissions() async {
    PermissionStatus cameraStatus = await Permission.camera.status;
    if (cameraStatus.isGranted) {
      return true;
    } else {
      return await requestCameraPermissions();
    }
  }

  /// Checks the current contact permissions status.
  ///
  /// If the contact permission is already granted, it returns `true`.
  /// Otherwise, it requests the contact permission and returns the result.
  ///
  /// Returns a [Future] that completes with `true` if the contact permission
  /// is granted, and `false` otherwise.
  static Future<bool> checkContactPermissions() async {
    PermissionStatus contactStatus = await Permission.contacts.status;
    if (contactStatus.isGranted) {
      return true;
    } else {
      return await requestContactPermissions();
    }
  }

  /// Checks the current call phone permissions status.
  ///
  /// If the call phone permission is already granted, it returns `true`.
  /// Otherwise, it requests the call phone permission and returns the result.
  ///
  /// Returns a [Future] that completes with `true` if the call phone permission
  /// is granted, and `false` otherwise.
  static Future<bool> checkCallPhonePermissions() async {
    PermissionStatus callPhoneStatus = await Permission.phone.status;
    if (callPhoneStatus.isGranted) {
      return true;
    } else {
      return await requestCallPhonePermissions();
    }
  }

  /// Checks the current location permissions status.
  ///
  /// If the location permission is already granted, it returns `true`.
  /// Otherwise, it requests the location permission and returns the result.
  ///
  /// Returns a [Future] that completes with `true` if the location permission
  /// is granted, and `false` otherwise.
  static Future<bool> checkLocationPermissions() async {
    PermissionStatus locationStatus = await Permission.location.status;
    if (locationStatus.isGranted) {
      return true;
    } else {
      return await requestLocationPermissions();
    }
  }

  /// Requests storage permissions from the user.
  ///
  /// This function uses the `permission_handler` package to request storage
  /// permissions. If the permission is already granted, it returns `true`.
  /// If the permission is permanently denied, it shows a dialog to inform
  /// the user and returns `false`. Otherwise, it requests the permission
  /// and returns the result.
  ///
  /// Returns:
  /// - `Future<bool>`: A future that resolves to `true` if the storage
  ///   permission is granted, otherwise `false`.
  static Future<bool> requestStoragePermissions() async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      showPermissionDialog('Lưu trữ');
      return false;
    } else {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.storage].request();
      return statuses[Permission.storage]?.isGranted ?? false;
    }
  }

  /// Requests camera permissions from the user.
  ///
  /// This function uses the `permission_handler` package to request storage
  /// permissions. If the permission is already granted, it returns `true`.
  /// If the permission is permanently denied, it shows a dialog to inform
  /// the user and returns `false`. Otherwise, it requests the permission
  /// and returns the result.
  ///
  /// Returns:
  /// - `Future<bool>`: A future that resolves to `true` if the camera
  ///   permissions were granted, otherwise `false`.
  static Future<bool> requestCameraPermissions() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      showPermissionDialog('Camera');
      return false;
    } else {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.camera].request();
      return statuses[Permission.camera]?.isGranted ?? false;
    }
  }

  /// Requests contact permissions from the user.
  ///
  /// This function uses the `permission_handler` package to request storage
  /// permissions. If the permission is already granted, it returns `true`.
  /// If the permission is permanently denied, it shows a dialog to inform
  /// the user and returns `false`. Otherwise, it requests the permission
  /// and returns the result.
  ///
  /// Returns:
  /// - `Future<bool>`: A future that resolves to `true` if the cotnact
  ///   permissions were granted, otherwise `false`.
  static Future<bool> requestContactPermissions() async {
    PermissionStatus status = await Permission.contacts.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      showPermissionDialog('Danh bạ');
      return false;
    } else {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.contacts].request();
      return statuses[Permission.contacts]?.isGranted ?? false;
    }
  }

  /// Requests call phone permissions from the user.
  ///
  /// This function uses the `permission_handler` package to request storage
  /// permissions. If the permission is already granted, it returns `true`.
  /// If the permission is permanently denied, it shows a dialog to inform
  /// the user and returns `false`. Otherwise, it requests the permission
  /// and returns the result.
  ///
  /// Returns:
  /// - `Future<bool>`: A future that resolves to `true` if the call phone
  ///   permission is granted, otherwise `false`.
  static Future<bool> requestCallPhonePermissions() async {
    PermissionStatus status = await Permission.phone.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      showPermissionDialog('Gọi điện');
      return false;
    } else {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.phone].request();
      return statuses[Permission.phone]?.isGranted ?? false;
    }
  }

  /// Requests location permissions from the user.
  ///
  /// This function uses the `permission_handler` package to request location
  /// permissions. If the permission is already granted, it returns `true`.
  /// If the permission is permanently denied, it shows a dialog to inform
  /// the user and returns `false`. Otherwise, it requests the permission
  /// and returns the result.
  ///
  /// Returns:
  /// - `Future<bool>`: A future that resolves to `true` if the location
  ///   permission is granted, otherwise `false`.
  static Future<bool> requestLocationPermissions() async {
    PermissionStatus status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      showPermissionDialog('Vị trí');
      return false;
    } else {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.location].request();
      return statuses[Permission.location]?.isGranted ?? false;
    }
  }

  /// Checks if the current platform is Android.
  ///
  /// Returns `true` if the platform is Android, otherwise `false`.
  static bool checkOsAndroidPlatform() {
    return Platform.isAndroid;
  }

  /// Checks the Android version of the device.
  ///
  /// This function uses the `DeviceInfoPlugin` to retrieve information about the
  /// Android device. It parses the Android version from the device info and compares
  /// it to a minimum required 12.
  ///
  /// Returns `true` if the Android version is greater than the minimum required version,
  /// otherwise returns `false`. If an error occurs while retrieving the device info,
  /// it shows an alert dialog with the message "Không thể xác định phiên bản Android"
  /// (Cannot determine Android version) and returns `false`.
  ///
  /// 12 is version dont need permission
  ///
  /// Throws:
  /// - `Exception` if there is an error while retrieving the device info.
  ///
  /// Example:
  /// ```dart
  /// bool isSupported = await checkAndroidVersion();
  /// if (isSupported) {
  ///   // Proceed with Android-specific functionality
  /// } else {
  ///   // Handle unsupported Android version
  /// }
  /// ```
  static Future<bool> checkAndroidVersion() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int androidVersion = int.parse(androidInfo.version.release);
      return androidVersion > 12;
    } catch (e) {
      return false;
    }
  }

  static Future<void> showPermissionDialog(String permission) async {
    Get.dialog(
      AlertDialog(
        title: Text('Yêu cầu quyền $permission'),
        content: Text(
            'Ứng dụng cần quyền $permission. Vui lòng cấp quyền trong Cài đặt.'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Hủy',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              openAppSettings();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HexColor.fromHex(ThemeColors.PRIMARY),
            ),
            child: const Text(
              'Mở Cài đặt',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
