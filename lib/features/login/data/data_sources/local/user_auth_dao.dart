import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/login/data/models/user_auth_model.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class UserAuthDao extends BaseDao<UserAuthModel> {
  UserAuthDao(Database db)
      : super(
          db: db,
          tableName: tableUser,
          modelFields: UserFields.values,
        );
  final prefs = GetIt.instance<SharedPreferences>();

  @override
  Future<UserAuthModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? UserAuthModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<UserAuthModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => UserAuthModel.fromMap(itemData)).toList();
  }

  Future<UserAuthModel?> readByUsernameOrEmail(String identifier) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'email = ? OR username = ?',
      whereArgs: [identifier, identifier],
    );

    return res.isNotEmpty ? UserAuthModel.fromMap(res[0]) : null;
  }

  // Future<bool> login(String identifier, String password) async {
  //   bool isLoggedIn = false;

  //   final UserModel? user = await readByUsernameOrEmail(identifier);

  //   if (user != null) {
  //     final hashedPassword = md5.convert(utf8.encode(password)).toString();

  //     if (hashedPassword == user.password) {
  //       // final prefs = GetIt.instance<SharedPreferences>();
  //       await prefs.setBool('logStatus', true);
  //       await prefs.setString('identifier', identifier);
  //       isLoggedIn = true;
  //     }
  //   }

  //   return isLoggedIn;
  // }

  // Future<void> logout() async {
  //   // final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isLoggedIn', false);
  // }

  // Future<bool> isLoggedIn() async {
  //   // final prefs = await SharedPreferences.getInstance();
  //   log("DAO $prefs");
  //   return prefs.getBool('isLoggedIn') ?? false;
  // }
}
