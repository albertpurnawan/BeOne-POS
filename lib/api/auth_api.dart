import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio = Dio();

  Future<String?> fetchBosToken(String email, String password) async {
    try {
      final response = await _dio.post(
        "http://192.168.1.34:3001/auth/login",
        data: {
          "email": email,
          "password": password,
        },
      );
      return response.data['token'];
    } catch (e) {
      print("Error fetching: $e");
      return null;
    }
  }
}
