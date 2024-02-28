import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/pricelist.dart';

class PricelistApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  PricelistApi(this._dio);

  Future<List<PricelistModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<PricelistModel> allData = [];

      while (hasMoreData) {
        final response = await _dio.get(
          "$url/tenant-pricelist?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        List<PricelistModel> data = (response.data as List)
            .map((e) => PricelistModel.fromMapRemote(e))
            .toList();
        allData.addAll(data);

        if (data.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }
      log(allData[0].toString());

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<PricelistModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-pricelist/docid/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log([response.data].toString());

      if (response.data == null) throw Exception('Null Data');

      PricelistModel datum = PricelistModel.fromMapRemote(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
