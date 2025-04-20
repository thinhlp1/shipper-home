import 'package:base/screens/guide/app_guide_screen.dart';
import 'package:base/screens/guide/info_screen.dart';
import 'package:base/utils/assets.dart';
import 'package:base/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      Assets.APP_ICON,
                      width: 200,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: const Text('Hướng dẫn sử dụng'),
              onTap: () {
                Get.to(const AppGuideScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Thông tin ứng dụng'),
              onTap: () {
                Get.to(const AboutScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback_outlined),
              title: const Text('Góp ý / Phản hồi'),
              onTap: () async {
                await launchUrl(Uri.parse(Constants.FORM_FEEDBACK_URL),
                    mode: LaunchMode.externalApplication);
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Đóng menu'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
