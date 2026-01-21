import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/features/auth/controller/auth_controller.dart';
import 'package:testing/view/SplashScreen.dart';

import 'constans/MyColor.dart';

void main() {
  runApp(const MyApp());
  Get.put(AuthController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp( // ✅ الحل هنا: استخدم GetMaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Close Friend CF',
      locale: const Locale('ar'), // لضبط اللغة العربية
      // ✅✅ أضف هذين السطرين لتفعيل الثيمات التي أنشأناها
      theme: MyColors.lightTheme,
      darkTheme: MyColors.darkTheme,

      // اجعل هذا تلقائي ليعتمد على النظام في البداية، أو سيتحكم به الكنترولر لاحقاً
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}