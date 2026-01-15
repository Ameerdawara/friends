import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class AuthService {
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await DioClient.dio.post(
      "/login",
      data: {
        "email": email,
        "password": password,
      },
    );
  }
}
