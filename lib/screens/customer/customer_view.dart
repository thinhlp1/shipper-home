import 'package:base/components/customer/customer_component.dart';
import 'package:base/config/global_store.dart';
import 'package:base/config/view_widget.dart';
import 'package:base/utils/hex_color.dart';
import 'package:base/models/customer.dart';
import 'package:base/screens/customer/add_customer/add_customer_view.dart';
import 'package:base/utils/text_field_validation.dart';
import 'package:base/utils/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import 'customer_action.dart';

class CustomerScreen extends StatefulWidget {
  @override
  // ignore: overridden_fields
  final Key? key;

  const CustomerScreen({
    this.key,
  }) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ViewWidget<CustomerScreen, CustomerAction> {
  @override
  CustomerAction createViewActions() => CustomerAction();

  @override
  Widget render(BuildContext context) {
    Utils.initCustomerSize();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Get.find<GlobalStore>().shouldFetchCustomer) {
        print("fetch golobal store");
        viewActions.fetchCustomers();
        Get.find<GlobalStore>().setShouldFetchCustomer(false);
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildTextFormFied(
            "Tìm kiếm khách hàng",
            context.watch<GlobalStore>().searchText,
            viewActions.searchController.value,
            TextFieldValidation.validName,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ReorderableListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: viewActions.filteredCustomer.length,
              itemBuilder: (BuildContext context, int index) {
                final customer = viewActions.filteredCustomer[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () {}),
                    children: [
                      SlidableAction(
                        foregroundColor: HexColor.fromHex(ThemeColors.PRIMARY),
                        borderRadius: BorderRadius.circular(10),
                        icon: Icons.delete,
                        autoClose: true,
                        spacing: 2,
                        label: 'Xóa',
                        onPressed: (BuildContext context) {
                          _showDeleteConfirmationDialog(
                              context, customer.id!, customer.name!);
                        },
                      ),
                    ],
                  ),
                  key: ValueKey(customer.id),
                  child: CustomerComponent(
                    customer: customer,
                    onFavoritePressed: (id) =>
                        viewActions.updateIsFavorite(id, !customer.isFavorite),
                    onCallPressed: (int id) => viewActions.callCustomer(id),
                    onEditPressed: (Customer customer) =>
                        _goToEditCustomer(customer),
                    onMapPressed: (String map) =>
                        viewActions.openGoogleMaps(map),
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                viewActions.reorderCustomer(oldIndex, newIndex);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addCustomer',
        onPressed: _goToAddCustomer,
        backgroundColor: HexColor.fromHex(ThemeColors.PRIMARY),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }

  /// Displays a confirmation dialog to confirm the deletion of a customer.
  ///
  /// This function shows a dialog with a confirmation message asking the user
  /// if they are sure they want to delete the customer. The dialog provides
  /// two buttons: "Hủy" (Cancel) and "Xác nhận" (Confirm). If the user
  /// confirms, the customer is deleted.
  ///
  /// Parameters:
  /// - `context`: The build context in which the dialog is displayed.
  /// - `id`: The ID of the customer to be deleted.
  /// - `name`: The name of the customer to be deleted.
  void _showDeleteConfirmationDialog(
      BuildContext context, int id, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text('Bạn có chắc chắn muốn xóa $name ?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                  ),
                  child: const Text('Hủy'),
                  onPressed: () {
                    Get.back();
                  },
                ),
                Utils.sizedBoWidth16,
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: HexColor.fromHex(ThemeColors.PRIMARY),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    viewActions.deleteCustomer(id);
                  },
                  child: const Text('Xác nhận'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Navigates to the AddCustomerView screen and updates the customer list.
  ///
  /// This method uses the GetX package to navigate to the AddCustomerView
  /// screen. After the navigation completes, it reloads the list of customers
  /// to reflect any new additions.
  void _goToAddCustomer() {
    // viewActions.resetDatabase();
    Get.to(() => AddCustomerView(
              position: viewActions.customers.length + 1,
            ))!
        .then((result) {
      if (result != null) {
        viewActions.fetchCustomers();
      }
    });
  }

  /// Navigates to the AddCustomerView screen with the provided customer data.
  ///
  /// This method uses the GetX package to navigate to the AddCustomerView
  /// screen with the provided customer data. After the navigation completes,
  /// it reloads the list of customers to reflect any changes.
  void _goToEditCustomer(Customer customer) {
    Get.to(() => AddCustomerView(
              position: customer.position,
              customer: customer,
            ))!
        .then((_) {
      viewActions.fetchCustomers();
    });
  }

  Widget _buildTextFormFied(
    String title,
    String initialValue,
    TextEditingController? textEditingController,
    FormFieldValidator<String>? validator,
  ) {
    if (initialValue.isNotEmpty) {
      textEditingController!.text = initialValue;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: TextFormField(
        controller: textEditingController,
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: Colors.black),
        validator: validator,
        onTapOutside: (event) =>
            {FocusManager.instance.primaryFocus?.unfocus()},
        onFieldSubmitted: (value) {
          viewActions.searchCustomer(value);
        },
        decoration: InputDecoration(
          hintText: title,
          prefixIcon: Icon(Icons.search,
              color: HexColor.fromHex(ThemeColors.SECONDARY)),
          suffixIcon: textEditingController!.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear,
                      color: HexColor.fromHex(ThemeColors.SECONDARY)),
                  onPressed: () {
                    textEditingController.clear();
                      Get.find<GlobalStore>().clearSearchText();
                    viewActions.searchCustomer('');
                  },
                )
              : null,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: HexColor.fromHex(ThemeColors.PRIMARY)),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        ),
      ),
    );
  }
}
