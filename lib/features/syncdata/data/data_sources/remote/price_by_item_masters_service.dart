import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class PriceByItemApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;
  String url = Constant.url;
  String tplnId = 'a776b020-b268-4c46-b1cc-59faf90321dc';

  PriceByItemApi(this.db);

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      List<Map<String, dynamic>> allData = [];

      final response = await dio.get(
        "$url/tenant-price-by-item/all/$tplnId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final List<Map<String, dynamic>> data =
          response.data.cast<Map<String, dynamic>>();
      allData.addAll(data);

      return allData;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSingleData(String docid) async {
    try {
      String itemName = 'SESA Volcano Roll / pack';
      final response = await dio.get(
        "$url/tenant-price-by-item/?price_period_id=$docid&page=1&search_item=$itemName",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log([response.data].toString());

      return response.data;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }
}
