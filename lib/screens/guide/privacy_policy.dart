import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class PrivacyPolicy {
  static Future<void> checkPrivacyPolicy() async {
    final prefs = await SharedPreferences.getInstance();
    final hasAcceptedPolicy = prefs.getBool('hasAcceptedPolicy') ?? false;

    if (!hasAcceptedPolicy) {
      _showPrivacyPolicyDialog();
    }
  }

  static void _showPrivacyPolicyDialog() {
    bool isChecked = false;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Chính sách bảo mật'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ứng dụng này không thu thập, lưu trữ hoặc chia sẻ bất kỳ dữ liệu cá nhân nào của người dùng ra bên ngoài.\n\nTất cả dữ liệu được lưu trữ sẽ không chia sẻ ra bên ngoài.',
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final url = Uri.parse(
                          'https://thinhlp1.github.io/shipper-home-privacy-policy/');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      } else {
                        Get.snackbar(
                          'Lỗi',
                          'Không thể mở liên kết.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: const Text(
                      'Đọc chính sách bảo mật đầy đủ tại đây.',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text('Tôi đã đọc kỹ chính sách bảo mật.'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: isChecked
                    ? () {
                        Get.back();
                        _acceptPrivacyPolicy();
                      }
                    : null, // Disable button if not checked
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                ),
              ),
            ],
          );
        },
      ),
      barrierDismissible: false, // Prevent dialog from being dismissed
    );
  }

  static Future<void> _acceptPrivacyPolicy() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasAcceptedPolicy', true);
  }
}
