import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/login/domain/entities/user_auth_entity.dart';
import 'package:pos_fe/features/login/domain/repository/user_auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUseCase implements UseCase<bool?, UserAuthEntity> {
  final UserAuthRepository _userAuthRepository;
  final SharedPreferences _prefs;

  LoginUseCase(UserAuthRepository userAuthRepository, SharedPreferences prefs)
      : _userAuthRepository = userAuthRepository,
        _prefs = prefs;

  @override
  Future<bool?> call({UserAuthEntity? params}) async {
    bool isLoggedIn = false;

    final UserAuthEntity? user = await _userAuthRepository
        .readByUsernameOrEmail(params!.email ?? params.username!);

    if (user != null) {
      final hashedPassword =
          md5.convert(utf8.encode(params.password!)).toString();

      if (hashedPassword == user.password) {
        await _prefs.setBool('logStatus', true);
        await _prefs.setString('email', user.email!);
        await _prefs.setString('username', user.username!);
        await _prefs.setString('tohemId', user.tohemId ?? "");
        await _prefs.setString('torolId', user.torolId!);

        isLoggedIn = true;
      }
    }

    return isLoggedIn;
  }
}
