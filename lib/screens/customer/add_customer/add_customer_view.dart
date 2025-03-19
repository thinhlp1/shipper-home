import 'dart:io';

import 'package:base/config/view_widget.dart';
import 'package:base/utils/hex_color.dart';
import 'package:base/models/customer.dart';
import 'package:base/utils/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_customer_action.dart';

class AddCustomerView extends StatefulWidget {
  final int position;
  final Customer? customer;

  const AddCustomerView({super.key, required this.position, this.customer});

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
        title: Text(widget.customer != null
            ? 'Cập nhật khách hàng'
            : 'Thêm khách hàng'),
      ),
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
                      style: Theme.of(context).textTheme.labelMedium,
                      decoration: InputDecoration(
                        labelText: 'Số điện thoại',
                        errorText: viewActions.phoneError.value,
                        hintStyle:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
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
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: viewActions.nameController,
                      style: Theme.of(context).textTheme.labelMedium,
                      decoration: InputDecoration(
                        labelText: 'Họ tên',
                        hintStyle:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                        errorText: viewActions.nameError.value,
                        prefixIcon: const Icon(Icons.person),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
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
                      controller: viewActions.addressController,
                      style: Theme.of(context).textTheme.labelMedium,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Địa chỉ',
                        errorText: viewActions.addressError.value,
                        hintStyle:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                        prefixIcon: const Icon(Icons.map),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
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
                      style: Theme.of(context).textTheme.labelMedium,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Ghi chú',
                        hintStyle:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                        errorText: viewActions.noteError.value,
                        prefixIcon: const Icon(Icons.edit),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: viewActions.getCurrentLocation,
                      child: const Text(
                        'Xác định vị trí',
                        style: TextStyle(color: Colors.blue),
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
                              child: Icon(
                                Icons.cancel,
                                color: HexColor.fromHex(ThemeColors.GREY),
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
                onPressed: () => widget.customer != null
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
                child: widget.customer != null
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
