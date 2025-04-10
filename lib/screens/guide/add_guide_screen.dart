import 'package:base/screens/guide/info_screen.dart';
import 'package:base/utils/hex_color.dart';
import 'package:base/utils/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddGuideScreen extends StatelessWidget {
  const AddGuideScreen({super.key});

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
            Image.asset('assets/images/guide/add_customer.png'),
            const SizedBox(height: 16),
            Text(
              'Chức năng thêm mới khách hàng',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: HexColor.fromHex(ThemeColors.PRIMARY)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.call, size: 20),
                const SizedBox(width: 8),
                Text('SĐT: ', style: Theme.of(context).textTheme.labelLarge),
                Text('Nhập số điện thoại - Bắt buộc',
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 20),
                const SizedBox(width: 8),
                Text('Tên khách hàng - ',
                    style: Theme.of(context).textTheme.labelLarge),
                Text('Không bắt buộc',
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.map, size: 20),
                const SizedBox(width: 8),
                Text('Địa chỉ - ',
                    style: Theme.of(context).textTheme.labelLarge),
                Text('Không bắt buộc',
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.note, size: 20),
                const SizedBox(width: 8),
                Text('Ghi chú - ',
                    style: Theme.of(context).textTheme.labelLarge),
                Text('Không bắt buộc',
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.my_location, size: 20),
                const SizedBox(width: 8),
                Text('Vị trí -', style: Theme.of(context).textTheme.labelLarge),
                Text('Ấn Icon để xác định vị trí hiện tại',
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.add_a_photo, size: 20),
                const SizedBox(width: 8),
                Text('Thêm ảnh - ',
                    style: Theme.of(context).textTheme.labelLarge),
                Text('Ấn để chụp hình ảnh',
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
