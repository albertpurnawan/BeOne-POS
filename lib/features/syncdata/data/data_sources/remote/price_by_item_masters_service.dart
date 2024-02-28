import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/features/sales/data/models/price_by_item.dart';

class PriceByItemApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;
  String tplnId = 'a776b020-b268-4c46-b1cc-59faf90321dc';

  PriceByItemApi(this._dio);

  Future<List<PriceByItemModel>> fetchData() async {
    try {
      List<PriceByItemModel> allData = [];

      final response = await _dio.get(
        "$url/tenant-price-by-item/all/$tplnId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      List<PriceByItemModel> data = (response.data as List)
          .map((e) => PriceByItemModel.fromMapRemote(e))
          .toList();
      allData.addAll(data);
      // log(allData[0].toString());
      return allData;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<PriceByItemModel> fetchSingleData(String docid) async {
    try {
      String itemName = 'SESA Volcano Roll / pack';
      final response = await _dio.get(
        "$url/tenant-price-by-item/?price_period_id=$docid&page=1&search_item=$itemName",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log(response.data.toString());

      PriceByItemModel datum = PriceByItemModel.fromMapRemote(response.data[0]);

      // log(datum.toString());
      return datum;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }
}
