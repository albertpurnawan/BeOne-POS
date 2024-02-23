import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class MOPApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;
  String url = "http://192.168.1.34:3001";

  MOPApi(this.db);

  Future<List<Map<String, dynamic>>> fetchMOPData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allMOPs = [];

      while (hasMoreData) {
        final response = await dio.get(
          "$url/tenant-means-of-payment/all/?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<Map<String, dynamic>> mopsData =
            response.data.cast<Map<String, dynamic>>();
        allMOPs.addAll(mopsData);

        if (mopsData.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      return allMOPs;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSingleMOP(String docid) async {
    try {
      final response = await dio.get(
        "$url/tenant-means-of-payment/docid/$docid",
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
