import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/constans/MyColor.dart';
import 'package:testing/view/loginPage.dart';
import 'package:testing/view/widget/OnBoardingScreen.dart';

import '../features/auth/controller/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء الكنترولر لبدء الفحص فور بناء الشاشة
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // أو MyColors.primary حسب تصميمك
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الأيقونة أو الشعار
            Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(border:  Border.all(color: MyColors.primary,width: 2.5),borderRadius: BorderRadius.circular(100)),
              child: CircleAvatar(
              radius: 100,

              backgroundImage: AssetImage('images/CF.webp',),),
            ),


            const SizedBox(height: 20),
            // مؤشر تحميل صغير (اختياري)
            const CircularProgressIndicator(color: MyColors.primary),
          ],
        ),
      ),
    );
  }
}
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkAuth();
  }

  void _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2)); // وقت ظهور الشعار

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final bool onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

    if (token != null && token.isNotEmpty) {
      // ✅ هنا نستدعي AuthController للتحقق من صحة التوكن
      // نستخدم Get.put للتأكد من وجود الكنترولر
      final authController = Get.put(AuthController());
      // نستدعي دالة الجلب ونخبرها أننا في وضع الفحص
      await authController.fetchUserProfile(isCheckingAuth: true);
    } else {
      // ❌ لا يوجد توكن
      if (onboardingSeen) {
        Get.offAll(() => const LoginPage());
      } else {
        Get.offAll(() => const OnBoardingScreen()); // أو صفحة OnBoarding الخاصة بك
      }
    }
  }
}
