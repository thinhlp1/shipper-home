import 'dart:io';

import 'package:base/api/Client.dart';
import 'package:base/config/GlobalStore.dart';
import 'package:base/config/Injection.dart';
import 'package:base/extensions/hex_color.dart';
import 'package:base/screens/main/View.dart';
import 'package:base/utils/theme_color.dart';
import 'package:base/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(
    ChangeNotifierProvider(
      create: (_) => GlobalStore(getIt<Client>()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Utils.initSize(context);
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: HexColor.fromHex(ThemeColors.PRIMARY),
        ),
        fontFamily: "Regular",
        textTheme: const TextTheme(
          labelSmall: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          labelMedium: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          labelLarge: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Medium",
            fontWeight: FontWeight.bold,
          ),
          bodySmall: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          bodyLarge: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Medium",
            fontWeight: FontWeight.bold,
          ),
          titleSmall: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          titleMedium: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          titleLarge: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Medium",
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          headlineMedium: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          headlineLarge: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Medium",
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          displayMedium: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          displayLarge: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "Medium",
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: HexColor.fromHex(ThemeColors.GREY),
          ),
          floatingLabelStyle: TextStyle(
            color: HexColor.fromHex(ThemeColors.PRIMARY),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: HexColor.fromHex(ThemeColors.PRIMARY),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: HexColor.fromHex(ThemeColors.GREY),
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          hintStyle: TextStyle(
            color: HexColor.fromHex(ThemeColors.GREY),
          ),
          alignLabelWithHint: true,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            fixedSize: Size(screenWidth - 32, 50),
            backgroundColor: HexColor.fromHex(ThemeColors.PRIMARY),
            disabledBackgroundColor: HexColor.fromHex(ThemeColors.GREY),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            textStyle: const TextStyle(
              fontFamily: "Medium",
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: HexColor.fromHex(ThemeColors.PRIMARY),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: "Medium",
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          shadowColor: Colors.black,

          // THIS IS BASE PROP
          // elevation: 10,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
