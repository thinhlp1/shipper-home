import 'package:base/utils/dialog_util.dart';
import 'package:base/utils/perrmission_util.dart';
import 'package:url_launcher/url_launcher.dart';

class CallService {
  /// Initiates a phone call to the specified phone number if the required
  /// permissions are granted.
  ///
  /// This function checks if the app has the necessary permissions to make
  /// phone calls. If the permissions are granted, it attempts to launch the
  /// phone dialer with the provided phone number. If the dialer cannot be
  /// launched, an alert dialog is displayed to inform the user.
  ///
  /// If the permissions are not granted, an alert dialog is shown to notify
  /// the user that the app requires call permissions.
  ///
  /// Parameters:
  /// - `phoneNumber`: The phone number to call. It should be a valid
  ///
  /// Throws:
  /// - Displays an alert dialog if the phone dialer cannot be launched or
  ///   if the required permissions are not granted.
  static Future<void> callPhoneNumber(String phoneNumber) async {
    if (await PermissionUtil.checkCallPhonePermissions()) {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        DialogUtil.alertDialog('Không thể thực hiện cuộc gọi');
      }
    }
  }
}
