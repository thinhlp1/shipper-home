import 'package:base/api/Client.dart';
import 'package:base/config/Injection.dart';
import 'package:base/config/ViewWidget.dart';
import 'package:base/screens/profile/edit-profile/EditProfileAction.dart';
import 'package:base/utils/text_field_validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState
    extends ViewWidget<EditProfileScreen, EditProfileAction> {
  @override
  EditProfileAction createViewActions() =>
      EditProfileAction(getIt<Client>(), context);

  final SizedBox _sizedBoxHeight8 = const SizedBox(height: 8);
  final SizedBox _sizedBoWidth16 = const SizedBox(width: 16);

  @override
  Widget render(BuildContext context) {
    double hightAvatar = 150;

    return Scaffold(
      appBar: header(title: "Thông tin cá nhân"),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: viewActions.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: hightAvatar,
                    margin: const EdgeInsets.only(bottom: 40),
                    child: GestureDetector(
                      onTap: viewActions.showImageSelectionDialog,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  const Color.fromARGB(255, 68, 67, 67)
                                      .withOpacity(0.7), // Màu xám mờ
                                  BlendMode.srcATop,
                                ),
                                child: viewActions.image.value?.exists() != null
                                    ? CircleAvatar(
                                        radius: 60,
                                        backgroundImage:
                                            FileImage(viewActions.image.value!),
                                      )
                                    : const CircleAvatar(
                                        radius: 60,
                                        backgroundImage:
                                            AssetImage("assets/no-avatar.png"),
                                      )),
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildTextFormFied(
                      "Họ và Tên",
                      viewActions.nameController.value,
                      TextFieldValidation.validName),

                  _sizedBoxHeight8,

                  _buildTextFormFied("Email", viewActions.emailController.value,
                      TextFieldValidation.validEmail),

                  _sizedBoxHeight8,

                  _buildDropdownButton("Giới tính", viewActions.gender,
                      viewActions.listGender, TextFieldValidation.validGender),

                  _sizedBoxHeight8,

                  //date of birht
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Text("Ngày sinh",
                        style: Theme.of(context).textTheme.labelMedium),
                  ),
                  TextFormField(
                      readOnly: true,
                      controller: viewActions.dobController.value,
                      onTap: viewActions.selectDate,
                      style: Theme.of(context).textTheme.labelSmall
                      // validator: TextFieldValidation.validDob,
                      ),

                  _sizedBoxHeight8,

                  _buildDropdownButton("Tỉnh/Thành Phố", viewActions.city,
                      viewActions.listCity, TextFieldValidation.validCity),

                  _sizedBoxHeight8,

                  _buildDropdownButton(
                      "Quận/Huyện",
                      viewActions.district,
                      viewActions.listDistrict,
                      TextFieldValidation.validDistrict),

                  _sizedBoxHeight8,

                  _buildDropdownButton("Phường/Xã", viewActions.ward,
                      viewActions.listWard, TextFieldValidation.validWard),

                  _sizedBoxHeight8,

                  _buildTextFormFied(
                      "Địa chỉ cụ thể",
                      viewActions.specificAddressController.value,
                      TextFieldValidation.validSpecificAddress),

                  _sizedBoxHeight8,

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(width: 1, color: Colors.grey.shade300),
                    )),
                    child: TextButton(
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)))),
                        onPressed: viewActions.logData,
                        child: const Text("Cập nhật ")),
                  ),
                ],
              ),
            ),
          ),
        ],
      ), // TODO: implement edit profile screen
    );
  }

  Widget _buildDropdownButton(String title, Rx<String?> value,
      List<String> items, FormFieldValidator<String>? validator) {
    void changeDropdownButton(val) {
      value.value = val!;
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        child: Text(title, style: Theme.of(context).textTheme.labelMedium),
      ),
      _sizedBoxHeight8,
      Container(
        child: Obx(() => DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: value.value,
                items: items
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    )
                    .toList(),
                validator: validator,
                onChanged: changeDropdownButton,
              ),
            )),
      ),
    ]);
  }

  Widget _buildTextFormFied(
      String title,
      TextEditingController? textEditingController,
      FormFieldValidator<String>? validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(title, style: Theme.of(context).textTheme.labelMedium),
        ),
        _sizedBoxHeight8,
        TextFormField(
            controller: textEditingController,
            style: Theme.of(context).textTheme.labelSmall,
            validator: validator)
      ],
    );
  }
}
