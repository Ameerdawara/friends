import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/view/loginPage.dart';
import 'package:testing/view/widget/OnBoardingScreen.dart'; // 1. تأكد من الاستيراد

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // ✅ الحل هنا: استخدم GetMaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Close Friend CF',
      locale: const Locale('ar'), // لضبط اللغة العربية
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const OnBoardingScreen(),
    );
  }
}