import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/view/loginPage.dart';

class OnBoardingController extends GetxController {
  var pageController = PageController();
  var currentIndex = 0.obs; // متغير مراقب لرقم الصفحة الحالية

  final List<Map<String, dynamic>> onBoardingData = [
    {
      "title": "Close Friend",
      "body": "تطبيقك الأول لكل خدمات منزلك.",
      "image": "images/CF.webp", // هذه موجودة عندك فعلياً
      "isAsset": true,
    },
    {
      "title": "خدمات منزلية شاملة",
      "body": "سباكة، كهرباء، حدادة، نجارة..",
      "icon": Icons.build_circle_outlined, // أيقونة جاهزة
      "isAsset": false,
    },
    {
      "title": "عقارات وتوصيل",
      "body": "بيع وشراء العقارات والتوصيل قريباً.",
      "icon": Icons.local_shipping_outlined, // أيقونة جاهزة
      "isAsset": false,
    },
  ];

  // دالة تحديث المؤشر عند السحب
  void onPageChanged(int index) {
    currentIndex.value = index;
  }
  Future<void> _completeOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true); // حفظ الحالة
  }

  // دالة الانتقال للصفحة التالية أو صفحة الدخول
  void next() async {
    if (currentIndex.value == onBoardingData.length - 1) {
      await _completeOnBoarding(); // حفظ الحالة قبل الانتقال
      Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  // دالة التخطي
  void skip() async {
    await _completeOnBoarding(); // حفظ الحالة قبل الانتقال
    Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
  }
}