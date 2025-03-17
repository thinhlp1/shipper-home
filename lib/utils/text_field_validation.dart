class TextFieldValidation {
  static String? isEmpty({String? value, String? errorText}) {
    String val = value ?? "";
    if (val.isEmpty) {
      return errorText ?? "";
    }
    return null;
  }

  static String? isPhoneNumber({String? value, String? errorText}) {
    String val = value ?? "";
    String pattern = r'(^(84|0[3|5|7|8|9])+([0-9]{8})\b)';
    return RegExp(pattern).hasMatch(val) ? null : errorText;
  }

  static String? isOTP({String? value, String? errorText}) {
    String val = value ?? "";
    String pattern = r'^\d{6}$';
    return RegExp(pattern).hasMatch(val) ? null : errorText;
  }

  static String? validName(String? value) {
    String val = value ?? "";
    if (val.isEmpty) {
      return "Vui lòng nhập họ và tên";
    }
    return null;
  }

  static String? validEmail(String? value) {
    String val = value ?? "";
    if (val.isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!RegExp(r"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$")
        .hasMatch(val)) {
      return 'Vui lòng nhập đúng email';
    }
    return null;
  }

  static String? validPhone(String? value) {
    String val = value ?? "";
    if (val.isEmpty) {
      return 'Vui lòng nhập số điện';
    }

    if (!RegExp(r'^0?[3|5|7|8|9][0-9]{8}$').hasMatch(val)) {
      return 'Vui lòng nhập đúng số điện thoại';
    }
    return null;
  }

  static String? validSpecificAddress(String? value) {
    String val = value ?? "";
    if (val.isEmpty) {
      return "Vui lòng nhập địa chỉ cụ thể";
    }
    return null;
  }

  //! cần bổ sung
  static String? validCity(String? value) {
    if (value == "Chọn Tỉnh/Thành Phố") {
      return "Vui lòng chọn Tỉnh/Thành Phố";
    }
    return null;
  }

  //! cần bổ sung
  static String? validDistrict(String? value) {
    if (value == "Chọn Quận/Huyện") {
      return "Vui lòng chọn Quận/Huyện";
    }
    return null;
  }

  //! cần bổ sung
  static String? validWard(String? value) {
    if (value == "Chọn Phường/Xã") {
      return "Vui lòng chọn Phường/Xã";
    }
    return null;
  }

  //! cần bổ sung
  static String? validGender(String? value) {
    if (value == "Chọn giới tính") {
      return "Vui lòng chọn giới tính";
    }
    return null;
  }

  static String? validDob(String? dateString) {
    DateTime birthDate = DateTime.parse(dateString!);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;

    if (currentDate.month < birthDate.month) {
      age--;
    } else if (currentDate.month == birthDate.month &&
        currentDate.day < birthDate.day) {
      age--;
    }

    if (age > 15) {
      return null;
    } else {
      return "Số tuổi phải lớn hơn 15";
    }
  }
}
