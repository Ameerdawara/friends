import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/view/loginPage.dart';

class OnBoardingController extends GetxController {
  var pageController = PageController();
  var currentIndex = 0.obs;

  final List<Map<String, dynamic>> onBoardingData = [
    {
      "title": "Close Friend",
      "body": "تطبيقك الأول لكل خدمات منزلك.",
      "image": "images/CF.webp",
      "isAsset": true,
    },
    {
      "title": "خدمات منزلية شاملة",
      "body": "سباكة، كهرباء، حدادة، نجارة..",
      "icon": Icons.build_circle_outlined,
      "isAsset": false,
    },
    {
      "title": "عقارات وتوصيل",
      "body": "بيع وشراء العقارات والتوصيل قريباً.",
      "icon": Icons.local_shipping_outlined,
      "isAsset": false,
    },
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
  Future<void> _completeOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true); // حفظ الحالة
  }

  // عند الانتهاء من الـ OnBoarding، نذهب دائماً لصفحة الدخول
  // لأن الـ Splash Screen تأكدت مسبقاً أنه ليس لديه حساب مسجل
  Future<void> _finishOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);

    Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
  }

  void next() async {
    if (currentIndex.value == onBoardingData.length - 1) {
      await _finishOnBoarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  void skip() async {
    await _finishOnBoarding();
  }
}