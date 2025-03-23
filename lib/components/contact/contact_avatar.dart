import 'package:base/models/user_contact.dart';
import 'package:base/utils/hex_color.dart';
import 'package:flutter/material.dart';

class ContactAvatar extends StatelessWidget {
  const ContactAvatar(this.userContact, this.size, {super.key});

  final UserContact userContact;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: HexColor.getColorGradient(userContact.color)),
        child: (userContact.contact.photo != null)
            ? CircleAvatar(
                backgroundImage: MemoryImage(userContact.contact.photo!),
              )
            : CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Text(userContact.contact.displayName[0],
                    style: const TextStyle(color: Colors.white))));
  }
}
