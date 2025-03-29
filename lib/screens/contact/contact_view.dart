import 'package:base/components/contact/contact_component.dart';
import 'package:base/config/view_widget.dart';
import 'package:base/screens/contact/contact_action.dart';
import 'package:base/utils/hex_color.dart';
import 'package:base/utils/text_field_validation.dart';
import 'package:base/utils/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            _buildTextFormFied(
              "Tìm kiếm liên hệ",
              viewActions.searchController.value,
              TextFieldValidation.validName,
            ),
            const SizedBox(height: 10),
            viewActions.contactsLoaded.value
                ? Expanded(
                    child: viewActions.filteredContacts.isEmpty
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
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            shrinkWrap: true,
                            itemCount: viewActions.filteredContacts.length,
                            itemBuilder: (context, index) {
                              final contact =
                                  viewActions.filteredContacts[index].contact;
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  dismissible:
                                      DismissiblePane(onDismissed: () {}),
                                  children: [
                                    SlidableAction(
                                      foregroundColor:
                                          HexColor.fromHex(ThemeColors.PRIMARY),
                                      borderRadius: BorderRadius.circular(10),
                                      icon: Icons.delete,
                                      autoClose: true,
                                      spacing: 2,
                                      label: 'Xóa',
                                      onPressed: (BuildContext context) {},
                                    ),
                                  ],
                                ),
                                key: ValueKey(contact.id),
                                child: ContactComponent(
                                  userContact:
                                      viewActions.filteredContacts[index],
                                  onAddCustomerPressed: (name, phone) {
                                    viewActions.goToAddCustomer(name, phone);
                                  },
                                  onCallPressed: (String phone) =>
                                      viewActions.callCustomerPhone(phone),
                                ),
                              );
                            },
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
