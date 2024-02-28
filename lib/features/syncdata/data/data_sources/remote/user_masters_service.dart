import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/syncdata/data/models/user_master_model.dart';

class UsersApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  UsersApi(this._dio);

  Future<List<UsersModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<UsersModel> allData = [];

      while (hasMoreData) {
        final response = await _dio.get(
          "$url/tenant-user?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        List<UsersModel> data =
            (response.data as List).map((e) => UsersModel.fromJson(e)).toList();
        // log(check.toString());
        allData.addAll(data);

        if (data.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<UsersModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-user/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log(response.data.toString());

      UsersModel datum = UsersModel.fromJson(response.data);

      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
