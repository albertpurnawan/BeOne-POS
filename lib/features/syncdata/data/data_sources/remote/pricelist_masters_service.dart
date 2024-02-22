import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class PricelistApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;
  String url = "http://192.168.1.34:3001";

  PricelistApi(this.db);

  Future<List<Map<String, dynamic>>> fetchPricelistsData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allPricelists = [];

      while (hasMoreData) {
        final response = await dio.get(
          "$url/tenant-pricelist?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<Map<String, dynamic>> pricelistsData =
            response.data.cast<Map<String, dynamic>>();
        allPricelists.addAll(pricelistsData);

        if (pricelistsData.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      return allPricelists;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSinglePricelist(String docid) async {
    try {
      final response = await dio.get(
        "$url/tenant-pricelist/docid/$docid",
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