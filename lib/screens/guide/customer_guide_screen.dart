import 'package:base/utils/hex_color.dart';
import 'package:base/utils/theme_color.dart';
import 'package:flutter/material.dart';

class CustomerGuidetScreen extends StatelessWidget {
  const CustomerGuidetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hướng dẫn sử dụng'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/guide/customer.png'),
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
            Text('- Ấn giữ để kéo thả vị trí',
                style: Theme.of(context).textTheme.labelLarge),
            Text('- Kéo qua phải để xóa',
                style: Theme.of(context).textTheme.labelLarge),
            Text('- Ấn 2 lần để sao chép',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 16),
            Text(
              'Chức năng quản lý khách hàng',
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
                Text('Tìm theo tên, SĐT, địa chỉ',
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
                const Icon(Icons.edit, size: 20),
                const SizedBox(width: 8),
                Text('Chỉnh sửa: ',
                    style: Theme.of(context).textTheme.labelLarge),
                Text('Chỉnh sửa thông tin KH',
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.delete, size: 20),
                const SizedBox(width: 8),
                Text('Xóa: ', style: Theme.of(context).textTheme.labelLarge),
                Text('Kéo qua phải để xóa',
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
            Row(
              children: [
                const Icon(Icons.map, size: 20),
                const SizedBox(width: 8),
                Text('Xem trên Map: ',
                    style: Theme.of(context).textTheme.labelLarge),
                Text('Xem vị trí KH trên Map',
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, size: 20),
                const SizedBox(width: 8),
                Text('Quan trọng: ',
                    style: Theme.of(context).textTheme.labelLarge),
                Text('Đánh dấu quan trọng cho KH',
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
