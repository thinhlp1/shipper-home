import 'package:base/config/ViewWidget.dart';
import 'package:base/extensions/hex_color.dart';
import 'package:base/screens/splash/Actions.dart';
import 'package:base/utils/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ViewWidget<SplashScreen, SplashActions> {
  @override
  SplashActions createViewActions() => SplashActions();

  @override
  Widget render(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logo-orderme.png",
                  width: 200,
                  height: 80,
                ),
                const SizedBox(height: 8),
                LoadingAnimationWidget.waveDots(
                  color: HexColor.fromHex(ThemeColors.PRIMARY),
                  size: 80,
                  key: GlobalKey(),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              color: Colors.white,
              child: Center(
                child: Text(
                  "@2023 All rights reserved",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
