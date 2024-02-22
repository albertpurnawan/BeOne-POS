import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class UoMApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;
  String url = "http://192.168.1.34:3001";

  UoMApi(this.db);

  Future<List<Map<String, dynamic>>> fetchUoMData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allUoM = [];

      while (hasMoreData) {
        final response = await dio.get(
          "$url/tenant-master-unit-of-measurement?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<Map<String, dynamic>> uomData =
            response.data.cast<Map<String, dynamic>>();
        allUoM.addAll(uomData);

        if (uomData.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      return allUoM;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSingleUoM(String docid) async {
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
