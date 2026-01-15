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
  }

  // Fetch user profile
  Future<void> fetchUserProfile() async {
    try {
      final response = await DioClient.dio.get("/user");
      currentUser.value = UserModel.fromJson(response.data);
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  // Logout function
  Future<void> logout() async {
    loading.value = true;
    try {
      await DioClient.dio.post("/logout");
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      currentUser.value = null;
      Get.offAll(() => const LoginPage());
    } catch (e) {
      Get.snackbar("خطأ", "فشل تسجيل الخروج، تأكد من الشبكة");
    } finally {
      loading.value = false;
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
      Get.off(HomePage());
    } catch (e) {
      Get.snackbar("خطأ", "بيانات الدخول غير صحيحة");
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
          "email_or_phone": emailOrPhone,
          "password": password,
          "password_confirmation": passwordConfirmation,
          "governorate": governorate,
          "city": city,
        },
      );

      final token = response.data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      Get.off(HomePage());
    } catch (e) {
      Get.snackbar("خطأ", "فشل إنشاء الحساب");
    }

    loading.value = false;
  }
}
