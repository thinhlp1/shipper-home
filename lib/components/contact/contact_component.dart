import 'package:base/components/contact/contact_component_action.dart';
import 'package:base/config/view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

class ContactComponent extends StatefulWidget {
  @override
  // ignore: overridden_fields
  final Key? key;
  final Contact contact;

  // final void Function(int) onFavoritePressed;
  // final void Function(int) onCallPressed;
  // final void Function(Contact) onEditPressed;
  // final void Function(String) onMapPressed;

  const ContactComponent({
    this.key,
    required this.contact,
    // required this.onFavoritePressed,
    // required this.onCallPressed,
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
    Contact contact = widget.contact;

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
            child: Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.displayName,
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
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
                // FavoriteButton(
                //     isFavorite: contact.isFavorite,
                //     onFavoritePressed: () {
                //       widget.onFavoritePressed(contact.id!);
                //     }),
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
                                onPressed: () => {},
                                iconSize: 25,
                                color: Colors.blue,
                                icon: const Icon(Icons.call)),
                            Text("Gọi",
                                style: Theme.of(context).textTheme.labelSmall!),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                                onPressed: () => {},
                                padding: const EdgeInsets.all(20),
                                iconSize: 25,
                                color: Colors.pink,
                                icon: const Icon(Icons.edit)),
                            Text("Thêm vào Khách hàng",
                                style: Theme.of(context).textTheme.labelSmall!),
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
