import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio = Dio();

  Future<AuthToken?> fetchAuthToken(String email, String password) async {
    try {
      final response = await _dio.post(
        "http://192.168.1.34:3001/auth/login",
        data: {
          "email": email,
          "password": password,
        },
      );

      final token = response.data['token'];

      if (token != null) {
        return AuthToken(token);
      }

      return null;
    } catch (e) {
      print("Error fetching: $e");
      return null;
    }
  }
}

class AuthToken {
  final String token;

  AuthToken(this.token);
}
