import 'package:base/config/global_store.dart';
import 'package:base/config/view_widget.dart';
import 'package:base/screens/guide/privacy_policy.dart';
import 'package:base/screens/guide/review_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:provider/provider.dart';

import '../../utils/hex_color.dart';
import '../../utils/theme_color.dart';
import 'actions.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainSreenState();
}

class _MainSreenState extends ViewWidget<MainScreen, MainActions> {
  @override
  void initState() {
    super.initState();

    // Đợi 1 chút để đảm bảo UI sẵn sàng
    Future.delayed(Duration.zero, () {
      PrivacyPolicy.checkPrivacyPolicy();
      ReviewApp.checkAndShowRateDialog();
    });
  }

  @override
  Widget render(BuildContext context) {
    return Scaffold(
      body: LazyLoadIndexedStack(
        index: context.watch<GlobalStore>().tabIndex,
        children: viewActions.views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedItemColor: HexColor.fromHex(ThemeColors.PRIMARY),
        unselectedItemColor: HexColor.fromHex(ThemeColors.GREY),
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(size: 25),
        selectedLabelStyle: const TextStyle(
          fontSize: 16,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 16),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Khách hàng",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Danh bạ",
          ),
        ],
        onTap: Get.find<GlobalStore>().handleChangeViews,
        currentIndex: context.watch<GlobalStore>().tabIndex,
      ),
    );
  }

  @override
  MainActions createViewActions() => MainActions();
}
