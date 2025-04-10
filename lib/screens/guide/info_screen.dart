import 'package:base/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin ứng dụng'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(Assets.APP_ICON, width: 200, height: 200),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ứng dụng quản lý khách hàng',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ứng dụng hỗ trợ ghi chú, tìm kiếm và quản lý khách hàng một cách nhanh chóng và tiện lợi.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const Text(
              'Thông tin người phát triển',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Lê Phước Thịnh'),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('lephuoccthinh@gmail.com'),
              onTap: () => _launchUrl('mailto:lephuoccthinh@gmail.com'),
            ),
            ListTile(
              leading: const Icon(Icons.facebook, color: Colors.blue),
              title: const Text('Facebook cá nhân'),
              onTap: () => _launchUrl(
                  'https://www.facebook.com/le.phuoc.thinh.146779/?locale=vi_VN'),
            ),
            const Spacer(),
            const Center(
              child: Text(
                'Phiên bản 1.0.0',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                '© 2025 Lê Phước Thịnh',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
