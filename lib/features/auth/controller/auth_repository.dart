import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class AuthRepository {
  final AuthService _service = AuthService();

  Future<void> login(String email, String password) async {
    final response = await _service.login(
      email: email,
      password: password,
    );

    final token = response.data['token'];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
}
