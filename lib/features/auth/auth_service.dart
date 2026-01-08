import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/dio_service.dart';

class AuthService {
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await DioService.dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      final token = response.data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return true;
    } on DioException catch (e) {
      print(e.response?.data);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await DioService.dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final token = response.data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return true;
    } on DioException catch (e) {
      print(e.response?.data);
      return false;
    }
  }

  Future<void> logout() async {
    await DioService.dio.post('/logout');

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
