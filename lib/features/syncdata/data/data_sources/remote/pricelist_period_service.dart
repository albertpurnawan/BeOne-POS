import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class PricelistPeriodApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;
  String url = "http://192.168.1.34:3001";
  String topln_id = '3d355ebf-ae71-4892-b09c-bdc8ae8f7331';

  PricelistPeriodApi(this.db);

  Future<List<Map<String, dynamic>>> fetchPricelistPeriodsData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allPricelistPeriods = [];

      while (hasMoreData) {
        final response = await dio.get(
          "$url/tenant-pricelist-period?page=$page&topln_id=$topln_id",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<Map<String, dynamic>> pricelistPeriodsData =
            response.data.cast<Map<String, dynamic>>();
        allPricelistPeriods.addAll(pricelistPeriodsData);

        if (pricelistPeriodsData.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      return allPricelistPeriods;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSinglePricelistPeriod(String docid) async {
    try {
      final response = await dio.get(
        "$url/tenant-pricelist-period/$docid",
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