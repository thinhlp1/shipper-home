import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:base/utils/constant.dart';
import 'dart:io';

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

  /// Requests storage permissions from the user.
  ///
  /// This function uses the `permission_handler` package to request storage
  /// permissions. It returns a `Future<bool>` indicating whether the storage
  /// permission was granted (`true`) or not (`false`).
  ///
  /// Returns:
  /// - `Future<bool>`: A future that resolves to `true` if the storage
  ///   permission is granted, otherwise `false`.
  static Future<bool> requestStoragePermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage].request();
    return statuses[Permission.storage]?.isGranted ?? false;
  }

  /// Requests camera permissions from the user.
  ///
  /// This function uses the `permission_handler` package to request camera
  /// permissions. It returns a `Future<bool>` indicating whether the camera
  /// permissions were granted (`true`) or not (`false`).
  ///
  /// Returns:
  /// - `Future<bool>`: A future that resolves to `true` if the camera
  ///   permissions were granted, otherwise `false`.
  static Future<bool> requestCameraPermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.camera].request();
    return statuses[Permission.camera]?.isGranted ?? false;
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
  /// it to a minimum required version defined in `Constants.minAndroidVersion`.
  ///
  /// Returns `true` if the Android version is greater than the minimum required version,
  /// otherwise returns `false`. If an error occurs while retrieving the device info,
  /// it shows an alert dialog with the message "Không thể xác định phiên bản Android"
  /// (Cannot determine Android version) and returns `false`.
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
      return androidVersion > Constants.minAndroidVersion;
    } catch (e) {
      return false;
    }
  }
}
