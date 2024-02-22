import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';
// import 'dart:developer';

class UsersApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;

  UsersApi(this.db);

  Future<List<Map<String, dynamic>>> fetchUsersData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allUsers = [];

      while (hasMoreData) {
        final response = await dio.get(
          "http://192.168.1.34:3001/tenant-user?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<Map<String, dynamic>> usersData =
            response.data.cast<Map<String, dynamic>>();
        allUsers.addAll(usersData);

        if (usersData.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      return allUsers;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSingleUser(String docid) async {
    try {
      final response = await dio.get(
        "http://192.168.1.34:3001/tenant-user/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log([response.data].toString());

      return [response.data];
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }
}
