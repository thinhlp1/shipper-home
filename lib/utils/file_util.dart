import 'dart:async';
import 'dart:io';
import 'package:base/utils/perrmission_util.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  /// Saves a list of images to the app-specific storage directory.
  /// This function does not require WRITE_EXTERNAL_STORAGE permission.
  /// The images will be stored in the app's specific directory.
  static Future<List<String?>> saveToGallery(List<String> imagePaths) async {
    List<String?> savedPaths = [];

    if (await PermissionUtil.checkStoragePermissions()) {
      Directory? appDir = await getApplicationDocumentsDirectory();

      for (String tempImagePath in imagePaths) {
        String newPath =
            '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final File tempImage = File(tempImagePath);
        final File newImage = await tempImage.copy(newPath);
        savedPaths.add(newImage.path);
      }
    } else {}

    return savedPaths;
  }

  /// Deletes an image from the app's storage directory.
  static Future<void> deleteImage(String imagePath) async {
    final File imageFile = File(imagePath);
    if (await imageFile.exists()) {
      await imageFile.delete();
    }
  }
}
