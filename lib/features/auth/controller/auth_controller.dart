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
    fetchUserProfile();
    checkLoginStatus();
  }

  // Fetch user profile
  // قمت بتعديل الدالة لتقبل متغير اختياري
  Future<void> fetchUserProfile({bool isCheckingAuth = false}) async {
    try {
      final response = await DioClient.dio.get("/user");
      currentUser.value = UserModel.fromJson(response.data);

      // ✅ إذا كنا في مرحلة التحقق من الدخول ونجح الجلب، نذهب للرئيسية
      if (isCheckingAuth) {
        Get.offAll(() => HomePage());
      }
      
    } catch (e) {
      print("Error fetching profile: $e");

      // ✅ معالجة الحالة الخطيرة: التوكن موجود في الهاتف لكنه محذوف من السيرفر
      if (e is DioException && e.response?.statusCode == 401) {
        // التوكن غير صالح (بسبب migrate:fresh مثلاً)
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear(); // تنظيف الذاكرة
        currentUser.value = null;
        
        // إجبار المستخدم على العودة لصفحة الدخول
        Get.offAll(() => const LoginPage());
      } 
      else if (isCheckingAuth) {
        // في حال وجود خطأ آخر (مثل انقطاع النت) أثناء فتح التطبيق
        // الخيار لك: إما تدخله للتطبيق أو تعيده للدخول. 
        // الأمان يقتضي إعادته للدخول إذا فشل التحقق
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

  // ✅ Update Profile Function (Fixed)
  Future<void> updateProfile({
    required String name,
    required String phone,
    String? city,
    String? imagePath,
  }) async {
    loading.value = true;
    try {
      // 1. Prepare data map
      Map<String, dynamic> dataMap = {
        "name": name,
        "phone": phone,
        "city": city,
        "_method": "PUT", // Laravel often needs this for file updates via POST
      };

      // 2. Create FormData using the 'dio' alias
      dio.FormData formData = dio.FormData.fromMap(dataMap);

      // 3. Attach image if exists
      if (imagePath != null && imagePath.isNotEmpty) {
        formData.files.add(MapEntry(
          "image",
          await dio.MultipartFile.fromFile(imagePath, filename: "profile_pic.jpg"),
        ));
      }

      // 4. Send request
      final response = await DioClient.dio.post("/profile/update", data: formData);

      // 5. Update local user data
      currentUser.value = UserModel.fromJson(response.data['user']);

      Get.back(); // Close edit page
      Get.snackbar("نجاح", "تم تحديث البيانات بنجاح", backgroundColor: Colors.green.withOpacity(0.2));
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
          "email": email,
          "password": password,
        },
      );
      final token = response.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      Get.offAll(HomePage());
    } catch (e) {
      Get.snackbar("خطأ", "بيانات الدخول غير صحيحة");
    if  (e is DioException) {
    print(e.response?.data);
  }
    }
    loading.value = false;
  }

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

      Get.offAll(HomePage());
    }catch (e) {
  if (e is DioException) {
    print(e.response?.data);
  }
  Get.snackbar('فشل إنشاء الحساب ' , 'خطأ');
}
finally {

    loading.value = false;
  }}
  
}
