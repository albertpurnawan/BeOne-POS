import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class StoreApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;
  String url = "http://192.168.1.34:3001";

  StoreApi(this.db);

  Future<List<Map<String, dynamic>>> fetchStoresData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allStores = [];

      while (hasMoreData) {
        final response = await dio.get(
          "$url/tenant-store-master?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<Map<String, dynamic>> storesData =
            response.data.cast<Map<String, dynamic>>();
        allStores.addAll(storesData);

        if (storesData.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      return allStores;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSingleStore(String docid) async {
    try {
      final response = await dio.get(
        "$url/tenant-store-master/$docid",
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
