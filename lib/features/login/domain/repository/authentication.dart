import 'dart:developer';

import 'package:pos_fe/features/login/data/data_sources/local/user_auth_dao.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite/sqflite.dart';

class AuthRepository {
  static const _loggedInKey = "is_logged_in";
  late final UserAuthDao _userAuthDao;

  AuthRepository(Database database) {
    _userAuthDao = UserAuthDao(database);
  }

  Future<bool> login(String username, String password) async {
    bool isLoggedIn = true;

    final UserModel? user = await _userAuthDao.readByUsername(username);

    if (user != null && password == user.password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loggedInKey, true);
      isLoggedIn = true;
    }

    return isLoggedIn;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }
}
