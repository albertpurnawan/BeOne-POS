import 'dart:developer';

import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class UserAuthDao extends BaseDao<UserModel> {
  static const _loggedInKey = "is_logged_in";
  UserAuthDao(Database db)
      : super(
          db: db,
          tableName: tableUser,
          modelFields: UserFields.values,
        );

  @override
  Future<UserModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? UserModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<UserModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => UserModel.fromMap(itemData)).toList();
  }

  Future<UserModel?> readByUsernameOrEmail(String identifier) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'email = ? OR username = ?',
      whereArgs: [identifier],
    );

    return res.isNotEmpty ? UserModel.fromMap(res[0]) : null;
  }

  Future<bool> login(String identifier, String password) async {
    bool isLoggedIn = false;

    final UserModel? user = await readByUsernameOrEmail(identifier);

    if (user != null && password == user.password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loggedInKey, true);
      await prefs.setString('identifier', identifier);
      final bool? check = prefs.getBool(_loggedInKey);
      log(check.toString());
      final String? checkStr = prefs.getString("identifier");
      log(checkStr.toString());
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
