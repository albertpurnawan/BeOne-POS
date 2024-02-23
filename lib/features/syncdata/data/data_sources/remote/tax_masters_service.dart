import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class TaxApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;
  String url = "http://192.168.1.34:3001";

  TaxApi(this.db);

  Future<List<Map<String, dynamic>>> fetchTaxesData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allTaxes = [];

      while (hasMoreData) {
        final response = await dio.get(
          "$url/tenant-tax-master?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<Map<String, dynamic>> taxesData =
            response.data.cast<Map<String, dynamic>>();
        allTaxes.addAll(taxesData);

        if (taxesData.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      return allTaxes;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSingleTax(String docid) async {
    try {
      final response = await dio.get(
        "$url/tenant-tax-master/$docid",
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
