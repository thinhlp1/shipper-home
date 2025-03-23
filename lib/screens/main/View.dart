import 'package:base/config/global_store.dart';
import 'package:base/config/view_widget.dart';
import 'package:flutter/material.dart';
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
  Widget render(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: context.watch<GlobalStore>().tabIndex,
        children: viewActions.views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedItemColor: HexColor.fromHex(ThemeColors.PRIMARY),
        unselectedItemColor: HexColor.fromHex(ThemeColors.GREY),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Khách hàng",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Quan trọng",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Danh bạ",
          )
        ],
        onTap: context.read<GlobalStore>().handleChangeViews,
        currentIndex: context.watch<GlobalStore>().tabIndex,
      ),
    );
  }

  @override
  MainActions createViewActions() => MainActions();
}
