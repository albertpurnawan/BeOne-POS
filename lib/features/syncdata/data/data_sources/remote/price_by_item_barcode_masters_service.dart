import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class PriceByItemBarcodeApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;
  String url = Constant.url;

  PriceByItemBarcodeApi(this.db);

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allData = [];
      String tpln2Id = '2bf74706-780f-448f-a351-1b87cc69069d';

      while (hasMoreData) {
        final response = await dio.get(
          "$url/tenant-price-by-item-barcode/?page=$page&tpln2_id=$tpln2Id",
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

      return allData;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSingleData(String docid) async {
    try {
      final response = await dio.get(
        "$url/tenant-price-by-item-barcode/$docid",
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
