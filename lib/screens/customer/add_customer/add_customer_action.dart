import 'dart:async';

import 'package:base/config/view_actions.dart';
import 'package:base/models/customer.dart';
import 'package:base/service/customer_service.dart';
import 'package:base/third_service/google_map_service.dart';
import 'package:base/utils/dialog_util.dart';
import 'package:base/utils/file_util.dart';
import 'package:base/utils/loading_util.dart';
import 'package:base/utils/perrmission_util.dart';
import 'package:base/utils/snackbar_util.dart';
import 'package:base/utils/text_field_validation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddCustomerAction extends ViewActions {
  final BuildContext context;

  AddCustomerAction(this.context);

  final CustomerService _customerService = CustomerService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mapController = TextEditingController();

  final RxString nameError = ''.obs;
  final RxString phoneError = ''.obs;
  final RxString noteError = ''.obs;
  final RxString addressError = ''.obs;
  final RxString mapError = ''.obs;

  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode noteFocusNode = FocusNode();

  final RxString mapPosition = ''.obs;

  RxList<String?> listImage = RxList();

  Position? position;

  /// Validates the phone number input field.
  ///
  /// This function checks the validity of the phone number entered in the
  /// `phoneController` text field. If the phone number is invalid, it sets
  /// the `phoneError` value to the validation error message and returns `false`.
  /// If the phone number is valid, it clears any previous error message and
  /// returns `true`.
  ///
  /// Returns:
  /// - `true` if the phone number is valid.
  /// - `false` if the phone number is invalid.
  bool validate() {
    bool isValid = true;

    final phoneValidation =
        TextFieldValidation.validPhone(phoneController.text);
    if (phoneValidation != null) {
      DialogUtil.alertDialog(phoneValidation);
      phoneFocusNode.requestFocus();
      isValid = false;
    } else {
      phoneError.value = '';
    }

    return isValid;
  }

  /// Populates the input fields with the provided customer details.
  /// - Parameters:
  ///   - customer: The customer object to populate the fields with.
  ///
  void populateFields(Customer customer) {
    nameController.text = customer.name ?? '';
    phoneController.text = customer.phone;
    noteController.text = customer.note;
    addressController.text = customer.address;
    mapController.text = customer.map;
    mapPosition.value = customer.map;

    listImage.addAll(customer.imageUrl);
  }

  /// Adds a new customer to the database if the input is valid.
  ///
  /// This function first validates the input fields. If the validation
  /// passes, it creates a new `Customer` object with the provided
  /// details and the current timestamp for creation and update times.
  ///
  /// The function save images to the gallery and save image paths to the database.
  ///
  /// The new customer is then saved using the `_customerService`.
  /// Finally, the function navigates back to the previous screen.
  ///
  /// Parameters:
  /// - `position`: The position of the customer in the list.
  ///
  /// Returns:
  /// A `Future` that completes when the customer has been saved.
  Future<void> addCustomer(int position) async {
    if (validate()) {
      final Customer newCustomer = Customer(
        name: nameController.text,
        phone: phoneController.text,
        note: noteController.text,
        address: addressController.text,
        map: mapController.text,
        position: position,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      int customerId = await _customerService.saveCustomer(newCustomer);

      // Save images to the gallery
      List<String?> savedImagePaths =
          await FileUtils.saveToGallery(listImage.whereType<String>().toList());

      // Save image paths to the database
      for (String? imagePath in savedImagePaths) {
        if (imagePath != null) {
          await _customerService.saveCustomerImage(customerId, imagePath);
        }
      }

      // Show success notification
      //
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
      SnackbarUtil.showSuccessSnackbar('Thành công', 'Thêm thành công');
    }
  }

  /// Updates the customer information and handles image updates.
  ///
  /// This function performs the following steps:
  /// 1. Updates the customer's details with the values from the respective controllers.
  /// 2. Retrieves the existing images associated with the customer.
  /// 3. Identifies images that need to be deleted and new images to be added.
  /// 4. Deletes images that are no longer needed from the file system and the database.
  /// 5. Saves new images to the gallery and updates the database with the new image paths.
  /// 6. Updates the customer information in the database.
  /// 7. Navigates back to the previous screen and shows a success snackbar.
  ///
  /// Parameters:
  /// - `customer`: The customer object to be updated.
  ///
  /// Returns:
  /// A `Future<void>` indicating the completion of the update operation.
  /// The selected image's file path is returned when the dialog is dismissed.
  Future<void> updateCustomer(Customer customer) async {
    if (validate()) {
      customer.name = nameController.text;
      customer.phone = phoneController.text;
      customer.note = noteController.text;
      customer.address = addressController.text;
      customer.map = mapController.text;
      customer.updatedAt = DateTime.now();

      // Get the existing images from the customer
      List<String?> existingImages = customer.imageUrl;

      // Find images to delete
      List<String?> imagesToDelete =
          existingImages.where((image) => !listImage.contains(image)).toList();

      // Find new images to add
      List<String?> newImages =
          listImage.where((image) => !existingImages.contains(image)).toList();

      // Delete images that are no longer needed
      for (String? imagePath in imagesToDelete) {
        if (imagePath != null) {
          await FileUtils.deleteImage(imagePath);
          await _customerService.deleteCustomerImage(customer.id!, imagePath);
        }
      }

      // Save new images to the gallery
      List<String?> savedImagePaths =
          await FileUtils.saveToGallery(newImages.whereType<String>().toList());

      // Save new image paths to the database
      for (String? imagePath in savedImagePaths) {
        if (imagePath != null) {
          await _customerService.saveCustomerImage(customer.id!, imagePath);
        }
      }

      await _customerService.updateCustomer(customer.id!, customer);

      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
      SnackbarUtil.showSuccessSnackbar('Thành công', 'Cập nhật thành công');
    }
  }

  /// Asynchronously adds an image to the list of images.
  ///
  /// This function displays an image selection dialog to the user. If the user
  /// selects an image and it is not empty, the image is added to the list of
  /// images (`listImage`).
  // Function to add an image to the list
  void addImage() async {
    String? image = await showImageSelectionDialog();
    if (image != null && image.isNotEmpty) {
      listImage.add(image);
    }
  }

  /// Removes an image from the list of images.
  /// - Parameters:
  ///   - index: The index of the image to remove.
  void removeImage(int index) {
    listImage.removeAt(index);
  }

  /// Picks an image from the specified source (camera or gallery).
  ///
  /// This function uses the `ImagePicker` to allow the user to select an image
  /// from either the camera or the gallery, depending on the provided `source`.
  /// It also checks for the necessary permissions before attempting to pick the image.
  ///
  /// If the source is `ImageSource.camera`, it checks for camera permissions.
  /// If the source is `ImageSource.gallery`, it checks for storage permissions.
  ///
  /// Returns a `Future<String>` that completes with the file path of the picked image,
  /// or an empty string if no image was picked or if permissions were not granted.
  ///
  /// Parameters:
  /// - `source`: The source from which to pick the image (`ImageSource.camera` or `ImageSource.gallery`).
  ///
  /// Returns:
  /// - A `Future<String>` containing the file path of the picked image, or an empty string if no image was picked.
  // Function to pick an image from the specified source (camera or gallery)
  Future<String> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    XFile? pickedImage;

    if (source == ImageSource.camera &&
        await PermissionUtil.checkCameraPermissions()) {
      pickedImage = await picker.pickImage(source: source);
    } else if (source == ImageSource.gallery &&
        await PermissionUtil.checkStoragePermissions()) {
      pickedImage = await picker.pickImage(source: source);
    }

    return pickedImage?.path ?? "";
  }

  /// Displays a dialog for image selection, allowing the user to choose between
  /// picking an image from the gallery or taking a new photo with the camera.
  ///
  /// Returns a [Future] that completes with the selected image's file path as a [String],
  /// or `null` if no image was selected.
  ///
  /// The dialog provides two options:
  /// - "Chọn từ thư viện" (Choose from library): Opens the gallery for image selection.
  /// - "Chụp ảnh" (Take photo): Opens the camera to take a new photo.
  ///
  /// The selected image's file path is returned when the dialog is dismissed.
  Future<String?> showImageSelectionDialog() {
    Completer<String?> completer = Completer<String?>();

    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            title: const Text('Chọn hình ảnh'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Chọn từ thư viện'),
                  onTap: () async {
                    String image = await pickImage(ImageSource.gallery);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, image);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Chụp ảnh'),
                  onTap: () async {
                    String image = await pickImage(ImageSource.camera);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, image);
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) => completer.complete(value));

    return completer.future;
  }

  /// Retrieves the current location of the user.
  ///
  /// This function shows a loading indicator while determining the user's
  /// current position using the `GoogleMapService`. Once the position is
  /// determined, it hides the loading indicator and updates the `mapPosition`
  /// and `mapController` with the latitude and longitude of the current position.
  Future<void> getCurrentLocation() async {
    LoadingUtil.showLoading();
    await Future.delayed(const Duration(milliseconds: 500));
    LoadingUtil.hideLoading();
    position = await GoogleMapService.determinePosition();
    if (position != null) {
      mapPosition.value =
          '${position!.latitude.toString()}, ${position!.longitude.toString()}';
      mapController.text = mapPosition.value;
    }
  }

  /// Opens Google Maps at the specified latitude and longitude.
  ///
  /// This function constructs a URL to open Google Maps with the given
  /// coordinates. If the URL can be launched, it will open Google Maps
  /// at the specified location. If the URL cannot be launched, it will
  /// display an alert dialog with an error message.
  ///
  /// Parameters:
  /// - mapPosition: The latitude and longitude of the location to open in Google Maps.
  Future<void> openGoogleMaps() async {
    if (mapPosition.value != '') {
      List<String> coordinates = mapPosition.value.split(',');
      double latitude = double.parse(coordinates[0].trim());
      double longitude = double.parse(coordinates[1].trim());
      await GoogleMapService.openGoogleMaps(
        latitude,
        longitude,
      );
    } else {
      DialogUtil.alertDialog('Vị trí chưa xác định');
    }
  }
}
