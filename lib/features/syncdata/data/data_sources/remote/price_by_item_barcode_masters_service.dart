import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/assign_price_member_per_store.dart';
import 'package:pos_fe/features/sales/data/models/price_by_item_barcode.dart';

class PriceByItemBarcodeApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  PriceByItemBarcodeApi(this._dio);

  Future<List<PriceByItemBarcodeModel>> fetchData() async {
    try {
      String apiName = "API-PRICEBARCODE";
      Map<String, dynamic> exeData = {};
      List<PriceByItemBarcodeModel> allData = [];

      final response = await _dio.get(
        "$url/tenant-custom-query/list",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      for (var api in response.data) {
        if (api["name"] == apiName) {
          exeData = {"docid": api["docid"], "parameter": []};
        }
      }

      final resp = await _dio.post("$url/tenant-custom-query/execute",
          data: exeData,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));

      if (resp.data['data'].isNotEmpty) {
        log("--- Price By Item Barcode ---");
        log(resp.data['data'][0].toString());

        List<PriceByItemBarcodeModel> data = (resp.data['data'] as List)
            .map((e) => PriceByItemBarcodeModel.fromMapRemote(e))
            .toList();
        allData.addAll(data);
      }

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<PriceByItemBarcodeModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-master-currency/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log(response.data.toString());
      if (response.data == null) throw Exception('Null Data');

      PriceByItemBarcodeModel datum =
          PriceByItemBarcodeModel.fromMap(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
