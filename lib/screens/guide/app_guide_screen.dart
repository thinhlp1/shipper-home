import 'package:base/screens/guide/info_screen.dart';
import 'package:base/utils/hex_color.dart';
import 'package:base/utils/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppGuideScreen extends StatelessWidget {
  const AppGuideScreen({super.key});

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
            // Section 1: Add Guide
            _buildSectionTitle('1. Thêm mới khách hàng', context),
            Image.asset('assets/images/guide/add_customer.png'),
            const SizedBox(height: 16),
            _buildRow(
                Icons.call, 'SĐT: ', 'Nhập số điện thoại - Bắt buộc', context),
            _buildRow(
                Icons.person, 'Tên khách hàng - ', 'Không bắt buộc', context),
            _buildRow(Icons.map, 'Địa chỉ - ', 'Không bắt buộc', context),
            _buildRow(Icons.note, 'Ghi chú - ', 'Không bắt buộc', context),
            _buildRow(Icons.my_location, 'Vị trí -',
                'Ấn Icon để xác định vị trí hiện tại', context),
            _buildRow(Icons.add_a_photo, 'Thêm ảnh - ', 'Ấn để chụp hình ảnh',
                context),

            const SizedBox(height: 16),
            Divider(
              color: HexColor.fromHex(ThemeColors.PRIMARY),
              thickness: 1,
            ),

            // Section 2: Customer Guide
            _buildSectionTitle('2. Quản lý khách hàng', context),
            Image.asset('assets/images/guide/customer.png'),
            const SizedBox(height: 16),
            _buildRow(Icons.search, 'Tìm kiếm: ', 'Tìm theo tên, SĐT, địa chỉ',
                context),
            _buildRow(
                Icons.person_add, 'Thêm mới: ', 'Thêm mới khách hàng', context),
            _buildRow(
                Icons.edit, 'Chỉnh sửa: ', 'Chỉnh sửa thông tin KH', context),
            _buildRow(Icons.delete, 'Xóa: ', 'Kéo qua trái để xóa', context),
            _buildRow(
                Icons.call, 'Gọi điện: ', 'Gọi điện cho khách hàng', context),
            _buildRow(
                Icons.map, 'Xem trên Map: ', 'Xem vị trí KH trên Map', context),
            _buildRow(Icons.star, 'Quan trọng: ', 'Đánh dấu quan trọng cho KH',
                context),

            const SizedBox(height: 16),
            Divider(
              color: HexColor.fromHex(ThemeColors.PRIMARY),
              thickness: 1,
            ),

            // Section 3: Contact Guide
            _buildSectionTitle('3. Xem danh bạ', context),
            Image.asset('assets/images/guide/contact.jpg'),
            const SizedBox(height: 16),
            _buildRow(Icons.search, 'Tìm kiếm: ', 'Tìm theo tên, SĐT', context),
            _buildRow(
                Icons.person_add, 'Thêm mới: ', 'Thêm mới khách hàng', context),
            _buildRow(
                Icons.call, 'Gọi điện: ', 'Gọi điện cho khách hàng', context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: HexColor.fromHex(ThemeColors.PRIMARY),
        ),
      ),
    );
  }

  Widget _buildRow(
      IconData icon, String title, String description, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          Text(description, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}
