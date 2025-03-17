import 'dart:async';
import 'dart:io';
import 'package:base/utils/perrmission_util.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  /// Saves a list of images to the device's gallery.
  ///
  /// This function takes a list of image file paths, requests storage permission,
  /// and if granted, copies each image to the external storage directory with a
  /// new name based on the current timestamp. The new paths of the saved images
  /// are returned as a list.
  ///
  /// If the storage permission is denied, a message "Permission Denied" is printed
  /// to the console.
  ///
  /// Returns a [Future] that completes with a list of new file paths of the saved images.
  ///
  /// - Parameter [imagePaths]: A list of file paths of the images to be saved.
  /// - Returns: A [Future] that completes with a list of new file paths of the saved images.
  static Future<List<String?>> saveToGallery(List<String> imagePaths) async {
    List<String?> savedPaths = [];

    if (await PermissionUtil.checkStoragePermissions()) {
      Directory? externalDir = await getExternalStorageDirectory();

      for (String tempImagePath in imagePaths) {
        String newPath =
            '${externalDir!.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final File tempImage = File(tempImagePath);
        final File newImage = await tempImage.copy(newPath);
        savedPaths.add(newImage.path);
      }
    } else {
      print("Permission Denied");
    }

    return savedPaths;
  }

  /// Deletes an image from the device's storage.
  ///
  /// This function takes the file path of an image and deletes the file from the device's storage.
  ///
  /// - Parameter [imagePath]: The file path of the image to be deleted.
  /// - Returns: A [Future] that completes when the image has been deleted.
  static Future<void> deleteImage(String imagePath) async {
    final File imageFile = File(imagePath);
    if (await imageFile.exists()) {
      await imageFile.delete();
    }
  }
}
