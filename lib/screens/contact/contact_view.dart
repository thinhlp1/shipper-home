import 'package:base/config/view_widget.dart';
import 'package:base/screens/contact/contact_action.dart';
import 'package:base/utils/hex_color.dart';
import 'package:base/utils/text_field_validation.dart';
import 'package:base/utils/theme_color.dart';
import 'package:flutter/material.dart';

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
            ListView.builder(
              shrinkWrap: true,
              itemCount: viewActions.contacts.length,
              itemBuilder: (context, index) {
                final contact = viewActions.contacts[index];
                return ListTile(
                  title: Text(contact.displayName),
                  subtitle: Text(contact.phones.first.number),
                );
              },
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
          // viewActions.searchCustomer(value);
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
                    // viewActions.searchCustomer('');
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
