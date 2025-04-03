import 'package:base/components/contact/contact_avatar.dart';
import 'package:base/components/contact/contact_component_action.dart';
import 'package:base/config/global_store.dart';
import 'package:base/config/view_widget.dart';
import 'package:base/models/user_contact.dart';
import 'package:base/utils/hex_color.dart';
import 'package:base/utils/snackbar_util.dart';
import 'package:base/utils/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:provider/provider.dart';

class ContactComponent extends StatefulWidget {
  @override
  // ignore: overridden_fields
  final Key? key;
  final UserContact userContact;

  final void Function(String name, String phone) onAddCustomerPressed;
  final void Function(String) onCallPressed;
  // final void Function(Contact) onEditPressed;
  // final void Function(String) onMapPressed;

  const ContactComponent({
    this.key,
    required this.userContact,
    required this.onAddCustomerPressed,
    required this.onCallPressed,
    // required this.onEditPressed,
    // required this.onMapPressed,
  }) : super(key: key);

  @override
  State<ContactComponent> createState() => _ContactComponenttState();
}

class _ContactComponenttState
    extends ViewWidget<ContactComponent, ContactComponentAction>
    with TickerProviderStateMixin {
  @override
  ContactComponentAction createViewActions() => ContactComponentAction();

  bool _toggle = false;

  /// Toggle size of container
  void _toggleSize() {
    setState(() {
      _toggle = !_toggle;
    });
  }

  @override
  Widget render(BuildContext context) {
    UserContact userContact = widget.userContact;
    Contact contact = userContact.contact;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, //  Auto size depend on children
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _toggleSize,
            onDoubleTap: () {
              Clipboard.setData(ClipboardData(
                text:
                    '${contact.displayName} - ${contact.phones.isNotEmpty ? contact.phones.first.number : ''}',
              ));
              SnackbarUtil.showScaffoldSnackbar(
                context,
                'Đã sao chép thông tin khách hàng',
              );
            },
            child: Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      ContactAvatar(widget.userContact, 40),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                userContact.contact.displayName,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              contact.phones.isNotEmpty
                                  ? contact.phones.first.number
                                  : 'Không có số điện thoại',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (userContact.isCustomer)
                  Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: HexColor.fromHex(ThemeColors.PRIMARY)),
                      const SizedBox(width: 5),
                      Text('Khách hàng',
                          style: TextStyle(
                            color: HexColor.fromHex(ThemeColors.PRIMARY),
                            fontSize: 13,
                          )),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Container for show images

          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _toggle
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            IconButton(
                                onPressed: () => {
                                      widget.onCallPressed(
                                        contact.phones.isNotEmpty
                                            ? contact.phones.first.number
                                            : '',
                                      )
                                    },
                                iconSize: 25,
                                color: Colors.blue,
                                icon: const Icon(Icons.call)),
                            Text("Gọi",
                                style: Theme.of(context).textTheme.labelSmall!),
                          ],
                        ),
                        Column(
                          children: [
                            userContact.isCustomer
                                ? Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          context
                                              .read<GlobalStore>()
                                              .switchToCustomerTabAndSearch(
                                                contact.phones.isNotEmpty
                                                    ? contact
                                                        .phones.first.number
                                                    : '',
                                              );
                                        },
                                        padding: const EdgeInsets.all(20),
                                        iconSize: 25,
                                        color: Colors.red,
                                        icon: const Icon(Icons.person),
                                      ),
                                      Text(
                                        "Xem Khách hàng",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!,
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      IconButton(
                                          onPressed: () => {
                                                widget.onAddCustomerPressed(
                                                    contact.displayName,
                                                    contact.phones.isNotEmpty
                                                        ? contact
                                                            .phones.first.number
                                                        : ''),
                                              },
                                          padding: const EdgeInsets.all(20),
                                          iconSize: 25,
                                          color: Colors.green,
                                          icon: const Icon(Icons.person_add)),
                                      Text("Thêm vào Khách hàng",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!),
                                    ],
                                  ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
