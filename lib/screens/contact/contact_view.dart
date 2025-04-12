import 'package:base/components/contact/contact_component.dart';
import 'package:base/config/view_widget.dart';
import 'package:base/screens/contact/contact_action.dart';
import 'package:base/screens/guide/contact_guide_screen.dart';
import 'package:base/utils/hex_color.dart';
import 'package:base/utils/text_field_validation.dart';
import 'package:base/utils/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';

class ContactScreen extends StatefulWidget {
  @override
  // ignore: overridden_fields
  final Key? key;

  const ContactScreen({
    this.key,
  }) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ViewWidget<ContactScreen, ContactAction> {
  @override
  ContactAction createViewActions() => ContactAction();

  @override
  Widget render(BuildContext context) {
    Utils.initCustomerSize();

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                Get.to(const ContactGuideScreen());
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            _buildTextFormFied(
              "Tìm kiếm liên hệ",
              viewActions.searchController.value,
              TextFieldValidation.validName,
            ),
            const SizedBox(height: 10),
            if (viewActions.contacts.isNotEmpty)
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          viewActions.filterIsCustomer(); // action lọc
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: viewActions.isCustomerFilter.value
                                ? HexColor.fromHex(ThemeColors.PRIMARY)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: HexColor.fromHex(ThemeColors.PRIMARY),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                                child: Icon(
                                  viewActions.isCustomerFilter.value
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  key: ValueKey<bool>(
                                      viewActions.isCustomerFilter.value),
                                  color: viewActions.isCustomerFilter.value
                                      ? Colors.white
                                      : HexColor.fromHex(ThemeColors.PRIMARY),
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: viewActions.isCustomerFilter.value
                                      ? Colors.white
                                      : HexColor.fromHex(ThemeColors.PRIMARY),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("Đã là khách hàng"),
                                    const SizedBox(width: 6),
                                    Row(
                                      children: [
                                        Text(
                                          '${viewActions.customerCount.value}',
                                          style: const TextStyle(
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.person,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tổng DB: ${viewActions.contacts.length}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: HexColor.fromHex(ThemeColors.PRIMARY),
                      ),
                    ),
                  )
                ],
              ),
            const SizedBox(height: 10),
            viewActions.contactsLoaded.value
                ? Expanded(
                    child: viewActions.contacts.isEmpty
                        ? Center(
                            child: GestureDetector(
                              onTap: () {
                                viewActions.fetchContacts();
                              },
                              child: Text(
                                'Tải lại danh bạ',
                                style: TextStyle(
                                    color:
                                        HexColor.fromHex(ThemeColors.PRIMARY),
                                    fontSize: 20),
                              ),
                            ),
                          )
                        : viewActions.filteredContacts.isEmpty
                            ? Center(
                                child: Text(
                                  'Không tìm thấy liên hệ',
                                  style: TextStyle(
                                      color:
                                          HexColor.fromHex(ThemeColors.PRIMARY),
                                      fontSize: 20),
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: () async {
                                  await viewActions.fetchCustomers();
                                  await viewActions.fetchContacts();
                                },
                                child: ListView.builder(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  shrinkWrap: true,
                                  itemCount:
                                      viewActions.filteredContacts.length,
                                  itemBuilder: (context, index) {
                                    final contact = viewActions
                                        .filteredContacts[index].contact;
                                    return Slidable(
                                      enabled: false,
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        dismissible:
                                            DismissiblePane(onDismissed: () {}),
                                        children: [
                                          SlidableAction(
                                            foregroundColor: HexColor.fromHex(
                                                ThemeColors.PRIMARY),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            icon: Icons.delete,
                                            autoClose: true,
                                            spacing: 2,
                                            label: 'Xóa',
                                            onPressed:
                                                (BuildContext context) {},
                                          ),
                                        ],
                                      ),
                                      key: ValueKey(contact.id),
                                      child: ContactComponent(
                                        userContact:
                                            viewActions.filteredContacts[index],
                                        onAddCustomerPressed: (name, phone) {
                                          viewActions.goToAddCustomer(
                                              name, phone);
                                        },
                                        onCallPressed: (String phone) =>
                                            viewActions
                                                .callCustomerPhone(phone),
                                      ),
                                    );
                                  },
                                ),
                              ),
                  )
                : const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(child: CircularProgressIndicator()),
                  )
          ],
        ));
  }

  Widget _buildTextFormFied(
    String title,
    TextEditingController? textEditingController,
    FormFieldValidator<String>? validator,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: TextFormField(
        controller: textEditingController,
        style: Theme.of(context)
            .textTheme
            .labelMedium!
            .copyWith(color: Colors.black),
        validator: validator,
        onTapOutside: (event) =>
            {FocusManager.instance.primaryFocus?.unfocus()},
        onFieldSubmitted: (value) {
          viewActions.searchContact(value);
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
                    viewActions.searchContact('');
                  },
                )
              : null,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
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
