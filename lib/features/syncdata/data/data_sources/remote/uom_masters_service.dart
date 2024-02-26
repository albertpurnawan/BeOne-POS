import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class UoMApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;
  String url = Constant.url;

  UoMApi(this.db);

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allData = [];

      while (hasMoreData) {
        final response = await dio.get(
          "$url/tenant-master-unit-of-measurement?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<Map<String, dynamic>> data =
            response.data.cast<Map<String, dynamic>>();
        allData.addAll(data);

        if (data.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      // for (var element in [allData[0]]) {
      //   element.forEach((key, value) {
      //     log('$key: ${value.runtimeType} $value');
      //   });
      // }

      return allData;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSingleData(String docid) async {
    try {
      final response = await dio.get(
        "$url/tenant-master-unit-of-measurement/$docid",
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
