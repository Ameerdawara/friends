import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/core/network/dio_client.dart';

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

      Get.offAllNamed("/home");
    } catch (e) {
      Get.snackbar("خطأ", "بيانات الدخول غير صحيحة");
    }

    loading.value = false;
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    loading.value = true;

    try {
      final response = await DioClient.dio.post(
        "/register",
        data: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
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
