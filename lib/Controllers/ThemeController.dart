import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // مفتاح الحفظ في الذاكرة
  final _key = 'isDarkMode';

  // متغير لمراقبة حالة الثيم
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  // تحميل الثيم المحفوظ عند فتح التطبيق
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool(_key) ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // دالة التبديل (يتم استدعاؤها عند ضغط الزر)
  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;

    // تغيير الثيم فورياً
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    // حفظ التغيير
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDarkMode.value);
  }
}