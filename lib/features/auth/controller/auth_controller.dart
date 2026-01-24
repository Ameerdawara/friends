import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Controllers/ThemeController.dart';
import '../../../core/network/dio_client.dart';
import '../../../data/model/user_model.dart';
import 'package:testing/view/loginPage.dart';
import '../../../view/HomePage.dart';

class AuthController extends GetxController {
  var loading = false.obs;

  // Reactive user model (حالة المستخدم العامة)
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  // ✅ هذه الدالة بقيت هنا لأنها جزء من عملية الـ Auth (التحقق من صحة التوكن)
  // تستخدم الرابط /user للحصول على كامل بيانات المستخدم
  Future<void> fetchUserProfile({bool isCheckingAuth = false}) async {
    try {
      final response = await DioClient.dio.get("/user");
      currentUser.value = UserModel.fromJson(response.data);

      if (isCheckingAuth) {
        Get.offAll(() => HomePage());
      }

    } catch (e) {
      print("Error fetching user session: $e");

      if (e is DioException && e.response?.statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        currentUser.value = null;
        Get.offAll(() => const LoginPage());
      }
      else if (isCheckingAuth) {
        Get.offAll(() => const LoginPage());
      }
    }
  }

  // ✅ التحقق من التوكن عند فتح التطبيق
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final bool onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

    if (token != null && token.isNotEmpty) {
      await fetchUserProfile(isCheckingAuth: true);
    } else {
      if (onboardingSeen) {
        Get.offAll(() => const LoginPage());
      } else {
        // Get.offAll(() => const OnBoardingScreen());
        Get.offAll(() => const LoginPage()); // مؤقتاً
      }
    }
  }

  // ✅ تسجيل الخروج
  Future<void> logout() async {
    loading.value = true;
    try {
      await DioClient.dio.post("/logout");
    } catch (e) {
      print("Logout error: $e");
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      // إعادة الثيم للوضع الفاتح يدوياً
      if (Get.isRegistered<ThemeController>()) {
        Get.find<ThemeController>().isDarkMode.value = false;
        Get.changeThemeMode(ThemeMode.light);
      }
      currentUser.value = null;
      loading.value = false;
      Get.offAll(() => const LoginPage());
    }
  }

  // ✅ تسجيل الدخول
  Future<void> login(String email, String password) async {
    loading.value = true;
    try {
      final response = await DioClient.dio.post(
        "/login",
        data: {
          "email": email,
          "password": password,
        },
      );
      final token = response.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // جلب بيانات المستخدم فوراً بعد الدخول
      await fetchUserProfile();

      Get.offAll(HomePage());
    } catch (e) {
      Get.snackbar("خطأ", "بيانات الدخول غير صحيحة");
      if (e is DioException) {
        print(e.response?.data);
      }
    } finally {
      loading.value = false;
    }
  }

  // ✅ إنشاء حساب جديد
  Future<void> register(
      String name,
      String emailOrPhone,
      String password,
      String passwordConfirmation,
      String governorate,
      String city,
      ) async {
    loading.value = true;
    try {
      final response = await DioClient.dio.post(
        "/register",
        data: {
          "name": name,
          "email": emailOrPhone,
          "password": password,
          "password_confirmation": passwordConfirmation,
          "governorate": governorate,
          "city": city,
        },
      );

      final token = response.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      await fetchUserProfile();

      Get.offAll(HomePage());
    } catch (e) {
      if (e is DioException) {
        print(e.response?.data);
        // عرض الخطأ القادم من الباك اند (مثل الايميل مكرر)
        Get.snackbar('فشل إنشاء الحساب', e.response?.data['message'] ?? 'خطأ غير معروف');
      } else {
        Get.snackbar('فشل إنشاء الحساب', 'خطأ');
      }
    } finally {
      loading.value = false;
    }
  }
}