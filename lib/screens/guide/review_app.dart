import 'package:base/utils/hex_color.dart';
import 'package:base/utils/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewApp {
  static Future<void> checkAndShowRateDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final hasRated = prefs.getBool('has_rated') ?? false;

    if (hasRated) return;
    final launchCount = prefs.getInt('launch_count') ?? 0;

    final newCount = launchCount + 1;
    await prefs.setInt('launch_count', newCount);

    if (newCount >= 5) {
      _showRateDialog();
    }
  }

  static void _showRateDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Bạn thích ứng dụng này chứ?"),
        content: const Text(
            "Hãy dành ít giây đánh giá giúp mình cải thiện app nhé!"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  textStyle: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                onPressed: () async {
                  Get.back();
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('has_rated', true); 
                },
                child: const Text("Không cảm ơn"),
              ),
              const SizedBox(width: 10),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: HexColor.fromHex(ThemeColors.PRIMARY),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                onPressed: () async {
                  Get.back();
                  final review = InAppReview.instance;
                  if (await review.isAvailable()) {
                    review.requestReview(); 
                  }
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('has_rated', true);
                },
                child: const Text("Đánh giá"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
