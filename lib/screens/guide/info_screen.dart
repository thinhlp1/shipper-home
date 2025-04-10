import 'package:base/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Không thể mở $url';
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
              title: const Text('shipper.home.app@gmail.com'),
              onTap: () => _launchUrl('mailto:shipper.home.app@gmail.com'),
            ),
            ListTile(
              leading: const Icon(Icons.facebook, color: Colors.blue),
              title: const Text('Fanpage Facebook'),
              onTap: () => _launchUrl(
                  'https://www.facebook.com/profile.php?id=61575337190094'),
            ),
            const Spacer(),
            if (version.isNotEmpty)
              Center(
                child: Text(
                  'Phiên bản $version',
                  style: const TextStyle(color: Colors.grey),
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
