import 'package:pos_fe/api/auth_api.dart';
import 'package:pos_fe/features/auth_bos/data/models/auth_token.dart';

class AuthService {
  final AuthApi _authApi = AuthApi();

  Future<AuthToken?> fetchAuthToken(String email, String password) async {
    final token = await _authApi.fetchBosToken(email, password);
    if (token != null) {
      return AuthToken(token);
    }
    return null;
  }
}
