import 'dart:io';

import 'package:base/config/view_widget.dart';
import 'package:base/screens/drawer/Sidebar.dart';
import 'package:base/utils/assets.dart';
import 'package:base/utils/hex_color.dart';
import 'package:base/models/customer.dart';
import 'package:base/utils/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_customer_action.dart';

class AddCustomerView extends StatefulWidget {
  final int position;
  final Customer? customer;
  final bool isAddFromContact;

  const AddCustomerView(
      {super.key,
      required this.position,
      this.customer,
      this.isAddFromContact = false});

  @override
  State<AddCustomerView> createState() => _AddCustomerViewState();
}

class _AddCustomerViewState
    extends ViewWidget<AddCustomerView, AddCustomerAction> {
  @override
  AddCustomerAction createViewActions() => AddCustomerAction(context);

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      // If a customer is provided, populate the fields with the customer's data
      viewActions.populateFields(widget.customer!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer != null && !widget.isAddFromContact
            ? 'Cập nhật khách hàng'
            : 'Thêm khách hàng'),
        actions: [
          Builder(
            // BẮT BUỘC dùng Builder để lấy đúng context
            builder: (context) => IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),
      drawer: Sidebar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Obx(
                    () => TextField(
                      controller: viewActions.phoneController,
                      focusNode: viewActions.phoneFocusNode,
                      style: Theme.of(context).textTheme.labelMedium,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(viewActions.nameFocusNode);
                      },
                      decoration: InputDecoration(
                        labelText: 'Số điện thoại',
                        errorText: viewActions.phoneError.value,
                        labelStyle:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: HexColor.fromHex(ThemeColors.PRIMARY),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear,
                              color: HexColor.fromHex(ThemeColors.SECONDARY)),
                          onPressed: () {
                            viewActions.phoneController.clear();
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(
                              color:
                                  Colors.blue), // Màu viền khi có lỗi và focus
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: viewActions.nameController,
                      focusNode: viewActions.nameFocusNode,
                      style: Theme.of(context).textTheme.labelMedium,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(viewActions.addressFocusNode);
                      },
                      decoration: InputDecoration(
                        labelText: 'Tên khách hàng',
                        labelStyle:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                        errorText: viewActions.nameError.value,
                        prefixIcon: Icon(
                          Icons.person,
                          color: HexColor.fromHex(ThemeColors.PRIMARY),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: viewActions.addressController,
                      focusNode: viewActions.addressFocusNode,
                      style: Theme.of(context).textTheme.labelMedium,
                      maxLines: 2,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        labelText: 'Địa chỉ',
                        errorText: viewActions.addressError.value,
                        labelStyle:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                        prefixIcon: Icon(
                          Icons.map,
                          color: HexColor.fromHex(ThemeColors.PRIMARY),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(
                              color:
                                  Colors.blue), // Màu viền khi có lỗi và focus
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: viewActions.noteController,
                      focusNode: viewActions.noteFocusNode,
                      style: Theme.of(context).textTheme.labelMedium,
                      maxLines: 2,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        labelText: 'Ghi chú',
                        labelStyle:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                        errorText: viewActions.noteError.value,
                        prefixIcon: Icon(
                          Icons.edit,
                          color: HexColor.fromHex(ThemeColors.PRIMARY),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: const BorderSide(
                              color:
                                  Colors.blue), // Màu viền khi có lỗi và focus
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
                  ),
                ],
              ),
              Obx(
                () => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Image.asset(
                        Assets.LOGO_GOOGLE_MAPS,
                        width: 40,
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: viewActions.mapController,
                        readOnly: true,
                        style: Theme.of(context).textTheme.labelMedium,
                        maxLines: 1,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Vị trí',
                          labelStyle:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                  ),
                          suffixIcon: GestureDetector(
                            onTap: viewActions.getCurrentLocation,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.my_location,
                                color: viewActions.mapPosition.value == ""
                                    ? HexColor.fromHex(ThemeColors.GREY)
                                    : HexColor.fromHex(ThemeColors.PRIMARY),
                              ),
                            ),
                          ),
                          errorText: viewActions.mapError.value,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: viewActions.openGoogleMaps,
                      child: Row(
                        children: [
                          const Text(
                            'Xem trên Google Maps',
                            style: TextStyle(color: Colors.blue),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(width: 5),
                          Image.asset(
                            Assets.LOGO_GOOGLE_MAPS,
                            width: 15,
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: viewActions.listImage.length + 1,
                  itemBuilder: (context, index) {
                    if (index == viewActions.listImage.length) {
                      return GestureDetector(
                        onTap: viewActions.addImage,
                        child: Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.add_a_photo,
                            color: HexColor.fromHex(ThemeColors.PRIMARY),
                            size: 35,
                          ),
                        ),
                      );
                    } else {
                      return Stack(
                        children: [
                          Image.file(
                            File(viewActions.listImage[index]!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () => viewActions.removeImage(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              }),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () =>
                    widget.customer != null && !widget.isAddFromContact
                        ? viewActions.updateCustomer(widget.customer!)
                        : viewActions.addCustomer(widget.position),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  fixedSize: Size(MediaQuery.of(context).size.width - 32, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Medium',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                child: widget.customer != null && !widget.isAddFromContact
                    ? const Text('Cập nhật')
                    : const Text('Thêm khách hàng'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget render(BuildContext context) {
    throw UnimplementedError();
  }
}
