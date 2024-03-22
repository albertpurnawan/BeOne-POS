import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class UserAuthDao extends BaseDao<UserModel> {
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
      whereArgs: [identifier, identifier],
    );

    return res.isNotEmpty ? UserModel.fromMap(res[0]) : null;
  }

  Future<bool> login(String identifier, String password) async {
    bool isLoggedIn = false;

    final UserModel? user = await readByUsernameOrEmail(identifier);

    if (user != null) {
      final hashedPassword = md5.convert(utf8.encode(password)).toString();

      if (hashedPassword == user.password) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('logStatus', true);
        await prefs.setString('identifier', identifier);
        isLoggedIn = true;
      }
    }

    return isLoggedIn;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    log("DAO $prefs");
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
