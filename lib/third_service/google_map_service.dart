import 'package:base/utils/dialog_util.dart';
import 'package:base/utils/perrmission_util.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapService {
  static LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  static Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        DialogUtil.alertDialog('Thiết bị chưa bật GPS');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          DialogUtil.alertDialog('Ứng dụng cần quyền truy cập vị trí');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        await PermissionUtil.showPermissionDialog('Vị trí');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);
    } catch (e) {
      // Handle the error here, e.g., log it or show a message to the user
      return null;
    }
  }

  /// Opens Google Maps at the specified latitude and longitude.
  ///
  /// This function constructs a URL to open Google Maps with the given
  /// coordinates. If the URL can be launched, it will open Google Maps
  /// at the specified location. If the URL cannot be launched, it will
  /// display an alert dialog with an error message.
  ///
  /// [latitude] The latitude of the location to open in Google Maps.
  /// [longitude] The longitude of the location to open in Google Maps.
  ///
  /// Throws an exception if the URL cannot be launched.
  static Future<void> openGoogleMaps(double latitude, double longitude) async {
    try {
      final Uri url = Uri.parse(
          "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        DialogUtil.alertDialog('Không thể mở Google Maps');
      }
    } catch (e) {
      DialogUtil.alertDialog('Đã xảy ra lỗi khi mở Google Maps');
    }
  }
}
