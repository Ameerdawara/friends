import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio; // ✅ CRITICAL FIX: Added 'as dio' alias

import '../../../core/network/dio_client.dart';
import '../../../data/model/user_model.dart';
import 'package:testing/view/loginPage.dart';

import '../../../view/HomePage.dart';

class AuthController extends GetxController {
  var loading = false.obs;

  // Reactive user model
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // fetchUserProfile();
    // checkLoginStatus();
  }

  Future<void> fetchUserProfile({bool isCheckingAuth = false}) async {
    try {
      final response = await DioClient.dio.get("/user");
      currentUser.value = UserModel.fromJson(response.data);

      if (isCheckingAuth) {
        Get.offAll(() => HomePage());
      }
    } catch (e) {
      print("Error fetching profile: $e");

      // معالجة الأخطاء (401: غير مصرح، 404: الرابط أو المستخدم غير موجود)
      if (e is DioException) {
        if (e.response?.statusCode == 401 || e.response?.statusCode == 404) {
          // التوكن فاسد أو المستخدم محذوف -> تنظيف الذاكرة
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          currentUser.value = null;

          // توجيه لصفحة الدخول
          Get.offAll(() => const LoginPage());
          return; // خروج من الدالة
        }
      }

      // إذا كان الخطأ شيئاً آخر (مثل انقطاع النت) ونحن في شاشة الفحص
      if (isCheckingAuth) {
        Get.offAll(() => const LoginPage());
      }
    }
  }
  // ✅ دالة جديدة للتحقق من التوكن عند فتح التطبيق
  // auth_controller.dart

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. التحقق من التوكن (هل هو مسجل دخول؟)
    final String? token = prefs.getString('token');

    // 2. التحقق من الـ Onboarding (هل شاهد الشاشات التعريفية؟)
    final bool onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

    if (token != null && token.isNotEmpty) {
      // إذا كان مسجل دخول، نحاول جلب بياناته والتأكد من صحة التوكن
      await fetchUserProfile(isCheckingAuth: true);
    } else {
      // إذا لم يكن مسجل دخول، نتحقق هل شاهد الـ Onboarding؟
      if (onboardingSeen) {
        // شاهدها سابقاً، نذهب لصفحة الدخول مباشرة
        Get.offAll(() => const LoginPage());
      } else {
        // أول مرة يدخل التطبيق، نذهب لصفحة الـ Onboarding
        // تأكد من استيراد OnBoardingScreen
        // Get.offAll(() => const OnBoardingScreen());
      }
    }
  }

  // Logout function
  Future<void> logout() async {
    loading.value = true;
    try {
      // محاولة إخبار السيرفر بمسح التوكن (اختياري لكن مفضل)
      await DioClient.dio.post("/logout");
    } catch (e) {
      print("Logout error from server: $e");
    } finally {
      // في كل الأحوال (سواء رد السيرفر أم لا) نمسح البيانات محلياً
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      currentUser.value = null;
      loading.value = false;
      Get.offAll(() => const LoginPage());
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String governorate, // ✅ إضافة المحافظة
    required String city,
    String? imagePath,
  }) async {
    loading.value = true;
    try {
      // 1. تجهيز البيانات
      Map<String, dynamic> dataMap = {
        "name": name,
        "phone": phone,
        "governorate": governorate, // ✅ إرسال المحافظة
        "city": city,
        "_method": "PUT",
      };

      // 2. إنشاء FormData
      dio.FormData formData = dio.FormData.fromMap(dataMap);

      // 3. إرفاق الصورة إن وجدت
      if (imagePath != null && imagePath.isNotEmpty) {
        formData.files.add(MapEntry(
          "image",
          await dio.MultipartFile.fromFile(imagePath,
              filename: "profile_pic.jpg"),
        ));
      }

      // 4. إرسال الطلب
      final response =
          await DioClient.dio.post("/profile/update", data: formData);

      // 5. تحديث البيانات محلياً
      currentUser.value = UserModel.fromJson(response.data['user']);

      Get.back(); // إغلاق الصفحة
      Get.snackbar("نجاح", "تم تحديث البيانات بنجاح",
          backgroundColor: Colors.green.withOpacity(0.2));
    } catch (e) {
      print("Update Error: $e");
      Get.snackbar("خطأ", "فشل التحديث");
    } finally {
      loading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    loading.value = true;
    try {
      final response = await DioClient.dio.post(
        "/login",
        data: {
          "email":
              email, // سنرسل الاسم بهذا الشكل ليتوافق مع لارفيل (ايميل أو هاتف)
          "password": password,
        },
      );

      final token = response.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // ✅ التعديل الحاسم: جلب بيانات المستخدم وتخزينها قبل الانتقال
      await fetchUserProfile();

      Get.offAll(() => HomePage()); // تأكد أن HomePage مستورد
    } catch (e) {
      loading.value = false; // إيقاف التحميل عند الخطأ
      Get.snackbar("خطأ", "بيانات الدخول غير صحيحة أو حدث خطأ في الاتصال");
      if (e is DioException) {
        print("Login Error: ${e.response?.data}");
      }
    } finally {
      loading.value = false;
    }
  }
// features/auth/controller/auth_controller.dart

  Future<void> register(
      String name,
      String emailOrPhone,
      String password,
      String passwordConfirmation,
      String governorate,
      String city,
      String? imagePath, // ✅ إضافة باراميتر الصورة
      ) async {
    loading.value = true;

    try {
      // 1. تحديد ما إذا كان المدخل ايميل أم هاتف (اختياري لتحسين الإرسال)
      bool isEmail = GetUtils.isEmail(emailOrPhone);

      // 2. استخدام FormData لإرسال الملفات والبيانات معاً
      dio.FormData formData = dio.FormData.fromMap({
        "name": name,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "governorate": governorate,
        "city": city,
        "role": "user",
        // نرسل القيمة للحقلين، والباك اند (لارفيل) سيتعامل معها كما شرحت لك سابقاً
        if (isEmail) "email": emailOrPhone else "phone": emailOrPhone,
      });

      // 3. إضافة الصورة إلى الطلب إذا كانت موجودة
      if (imagePath != null && imagePath.isNotEmpty) {
        formData.files.add(MapEntry(
          "image", // اسم الحقل في لارفيل
          await dio.MultipartFile.fromFile(imagePath, filename: "avatar.jpg"),
        ));
      }

      // 4. إرسال الطلب (لاحظ نستخدم formData بدلاً من data)
      final response = await DioClient.dio.post("/register", data: formData);

      // حفظ التوكن وجلب البيانات
      final token = response.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      await fetchUserProfile();
      Get.offAll(() => HomePage());

    } catch (e) {
      if (e is DioException) {
        print("Register Error: ${e.response?.data}");
        Get.snackbar('فشل الإنشاء', e.response?.data['message'] ?? 'تأكد من البيانات');
      }
    } finally {
      loading.value = false;
    }
  }
}
