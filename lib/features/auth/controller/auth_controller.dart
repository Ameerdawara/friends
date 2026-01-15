import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/view/HomePage.dart';

import '../../../core/network/dio_client.dart';

class AuthController extends GetxController {
  var loading = false.obs;
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

      Get.offAllNamed("/home");
    } catch (e) {
      Get.snackbar("خطأ", "فشل إنشاء الحساب");
    }

    loading.value = false;
  }
}
