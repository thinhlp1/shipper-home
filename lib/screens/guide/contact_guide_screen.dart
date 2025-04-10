import 'package:base/screens/guide/info_screen.dart';
import 'package:base/utils/hex_color.dart';
import 'package:base/utils/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactGuideScreen extends StatelessWidget {
  const ContactGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hướng dẫn sử dụng'),
         actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Get.to(const AboutScreen());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/guide/contact.jpg'),
            const SizedBox(height: 16),
            Text(
              'Thao tác',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: HexColor.fromHex(ThemeColors.PRIMARY)),
            ),
            const SizedBox(height: 8),
            Text('- Ấn để xem chi tiết',
                style: Theme.of(context).textTheme.labelLarge),
            Text('- Ấn 2 lần để sao chép',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 16),
            Text(
              'Chức năng xem danh bạ',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: HexColor.fromHex(ThemeColors.PRIMARY)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.search, size: 20),
                const SizedBox(width: 8),
                Text('Tìm kiếm: ',
                    style: Theme.of(context).textTheme.labelLarge),
                Text('Tìm theo tên, SĐT',
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_add, size: 20),
                const SizedBox(width: 8),
                Text('Thêm mới: ',
                    style: Theme.of(context).textTheme.labelLarge),
                Text('Thêm mới khách hàng',
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.call, size: 20),
                const SizedBox(width: 8),
                Text('Gọi điện: ',
                    style: Theme.of(context).textTheme.labelLarge),
                Text('Gọi điện cho khách hàng',
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
