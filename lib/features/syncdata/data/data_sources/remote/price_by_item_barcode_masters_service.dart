import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/price_by_item_barcode.dart';

class PriceByItemBarcodeApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  PriceByItemBarcodeApi(this._dio);

  Future<List<PriceByItemBarcodeModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<PriceByItemBarcodeModel> allData = [];
      String tpln2Id = '2bf74706-780f-448f-a351-1b87cc69069d';

      while (hasMoreData) {
        final response = await _dio.get(
          "$url/tenant-price-by-item-barcode/?page=$page&tpln2_id=$tpln2Id",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        List<PriceByItemBarcodeModel> data = (response.data as List)
            .map((e) => PriceByItemBarcodeModel.fromMapRemote(e))
            .toList();
        allData.addAll(data);

        if (data.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }
      // log(allData[0].toString());

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<PriceByItemBarcodeModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-price-by-item-barcode/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log([response.data].toString());

      if (response.data == null) throw Exception('Null Data');

      PriceByItemBarcodeModel datum =
          PriceByItemBarcodeModel.fromMapRemote(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
