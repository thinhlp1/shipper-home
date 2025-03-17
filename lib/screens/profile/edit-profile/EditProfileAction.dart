import 'dart:io';

import 'package:base/api/Client.dart';
import 'package:base/config/ViewActions.dart';
import 'package:base/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info/device_info.dart';

class EditProfileAction extends ViewActions {
  final Client _client;
  final BuildContext context;

  EditProfileAction(this._client, this.context);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Rxn<TextEditingController> nameController = Rxn(TextEditingController());
  Rxn<TextEditingController> emailController = Rxn(TextEditingController());
  Rxn<TextEditingController> dobController = Rxn(TextEditingController());
  Rxn<TextEditingController> specificAddressController =
      Rxn(TextEditingController());

  Rxn<File> image = Rxn();

  final Rx<String?> city = Rx<String?>('');
  final Rx<String?> district = Rx<String?>('');
  final Rx<String?> ward = Rx<String?>('');
  final Rx<String?> gender = Rx<String?>('');

  final RxList<String> listCity = RxList<String>();
  final RxList<String> listDistrict = RxList<String>();
  final RxList<String> listWard = RxList<String>();
  final RxList<String> listGender = RxList<String>();

  @override
  void initState() {
    nameController.value?.text = 'Lê Phước Thịnh';
    emailController.value?.text = 'alanthinh3@gmail.com';
    specificAddressController.value?.text = 'đường số 51';
    dobController.value?.text = "01/01/1990";

    city.value = "Thành phố Cần Thơ";
    district.value = "Quận Ninh Kiều";
    ward.value = "Phường An Khánh";
    gender.value = "Nam";

    city.value = ""; //? in case user don't have city
    district.value = ""; //? in case user don't have city
    ward.value = ""; //? in case user don't have city

    loadCity();
    loadWard();
    loadDistrict();
    loadGender();
  }

  void loadCity() {
    if (city.value == "") {
      city.value = "Chọn Tỉnh/Thành Phố";
      listCity.add("Chọn Tỉnh/Thành Phố");
    }
    listCity.add("Thành phố Cần Thơ");
    listCity.add("Thành phố Hồ Chí Minh");
    listCity.add("Thành phố Hà Nội");
    listCity.add("Thành phố Đà Nẵng");
  }

  void loadWard() {
    if (ward.value == "") {
      ward.value = "Chọn Phường/Xã";
      listWard.add("Chọn Phường/Xã");
    }
    listWard.add("Phường An Khánh");
    listWard.add("Phường An Bình");
    listWard.add("Phường An Hòa");
  }

  void loadDistrict() {
    if (district.value == "") {
      district.value = "Chọn Quận/Huyện";
      listDistrict.add("Chọn Quận/Huyện");
    }
    listDistrict.add("Quận Ninh Kiều");
    listDistrict.add("Quận Cái Răng");
  }

  void loadGender() {
    if (gender.value == "") {
      gender.value = "Chọn giới tính";
      listGender.add("Chọn giới tính");
    }
    listGender.add("Nam");
    listGender.add("Nữ");
  }

  void logData() {
    if (formKey.currentState!.validate()) {
      print("Họ và tên: ${nameController.value!.text}");
      print("Email: ${emailController.value!.text}");
      print("Giới tính: ${gender.value!}");
      print("Thành phố: ${city.value!}");
      print("Ngày sinh: ${dobController.value!.text}");
      print("Quận: ${district.value!}");
      print("Xã: ${ward.value!}");
      print("Địa chỉ cụ thể: ${specificAddressController.value!.text}");
      print("Hình ảnh: ${image.value!.path}");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    XFile? pickedImage;

    if (source == ImageSource.camera) {
      if (await checkCameraPermissions()) {
        pickedImage = await picker.pickImage(source: source);
      }
    } else if (source == ImageSource.gallery) {
      if (await checkStoragePermissions()) {
        pickedImage = await picker.pickImage(source: source);
      }
    }

    if (pickedImage != null) {
      image.value = File(pickedImage.path);
    }
  }

  void showImageSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            title: const Text('Chọn ảnh'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Chọn ảnh từ thư viện'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Chụp ảnh'),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void selectDate() async {
    ThemeData defaultTheme = ThemeData();
    ThemeData datePickerTheme = defaultTheme.copyWith();
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: datePickerTheme,
          child: child!,
        );
      },
    );

    if (date != null) {
      dobController.value!.text = Utils.formatDate(date);
    }
  }

  Future<bool> checkStoragePermissions() async {
    if (checkOsAndroidPlatform() && await checkAndroidVersion()) {
      print("CHECK");
      return true;
    }

    PermissionStatus storageStatus = await Permission.storage.status;
    if (storageStatus.isGranted) {
      print('Ứng dụng có quyền đọc/ghi file');
      return true;
    } else {
      print('Ứng dụng không có quyền đọc/ghi file');
      return await requestStoragePermissions();
    }
  }

  Future<bool> checkCameraPermissions() async {
    PermissionStatus cameraStatus = await Permission.camera.status;

    if (cameraStatus.isGranted) {
      print('Ứng dụng có quyền truy cập camera');
      return true;
    } else {
      print('Ứng dụng không có quyền truy cập camera');
      return await requestCameraPermissions();
    }
  }

  Future<bool> requestStoragePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    if (statuses[Permission.storage]!.isGranted) {
      print('Quyền đọc/ghi file đã được cấp');
      return true;
    } else {
      print('Ứng dụng không có quyền đọc/ghi file');
      return false;
    }
  }

  Future<bool> requestCameraPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();

    if (statuses[Permission.camera]!.isGranted) {
      print('Quyền truy cập camera đã được cấp');
      return true;
    } else {
      print('Ứng dụng không có quyền truy cập camera');
      return false;
    }
  }

  bool checkOsAndroidPlatform() {
    print(Platform.isAndroid);
    return Platform.isAndroid;
  }

  Future<bool> checkAndroidVersion() async {
    AndroidDeviceInfo androidInfo;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      androidInfo = await deviceInfo.androidInfo;
      var androidVersion = androidInfo.version.release;
      print("ANDROID VERSION: $androidVersion");
      if (int.parse(androidVersion) > 12) {
        print("Phiên bản Android lớn hơn 12");
        return true;
      } else {
        print("Phiên bản Android không lớn hơn 12");
        return false;
      }
    } catch (e) {
      print("Lỗi khi lấy thông tin thiết bị: $e");
      showQuickAlertDialog("Không thể xác nhận phiên bản Android");
      return false;
    }
  }

  void showQuickAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
