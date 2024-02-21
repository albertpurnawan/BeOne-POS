import 'package:dio/dio.dart';
import 'package:pos_fe/api/users/users_model.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'dart:developer';
import 'package:pos_fe/core/database/app_database.dart';

class UsersApi {
  final AppDatabase _appdatabase = AppDatabase();
  final dio = Dio();
  String token = Constant.token;

  Future<List<dynamic>> fetchUsersData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<dynamic> allUsers = [];

      while (hasMoreData) {
        final response = await dio.get(
          "http://192.168.1.34:3001/tenant-user?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<dynamic> usersData = response.data as List<dynamic>;
        allUsers.addAll(usersData);

        if (usersData.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      final List<Users> users =
          allUsers.map((json) => Users.fromJson(json)).toList();

      // log(response.data[0].toString());
      // log(users[0].toString());

      for (final user in users) {
        await _appdatabase.insertUsers(user);
      }

      return allUsers;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchUserData(String docid) async {
    try {
      final response = await dio.get(
        "http://192.168.1.34:3001/tenant-user/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // response.data.forEach((key, value) {
      //   print('$key: $value');
      // });

      final Users user = Users.fromJson(response.data);

      // print('User: $user');

      return [response.data];
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }
}
