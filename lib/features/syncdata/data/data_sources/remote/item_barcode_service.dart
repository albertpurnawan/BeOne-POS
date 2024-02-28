import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/item_barcode.dart';

class ItemBarcodeApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;
  String toitm_id = '338d765e-38fc-4f9b-b24f-039d407fd66c';

  ItemBarcodeApi(this._dio);

  Future<List<ItemBarcodeModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<ItemBarcodeModel> allData = [];

      while (hasMoreData) {
        final response = await _dio.get(
          "$url/tenant-barcode-item?toitm_id=$toitm_id&page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        List<ItemBarcodeModel> data = (response.data as List)
            .map((e) => ItemBarcodeModel.fromMapRemote(e))
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

  Future<ItemBarcodeModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-barcode-item/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log([response.data].toString());

      ItemBarcodeModel datum = ItemBarcodeModel.fromMapRemote(response.data);
      log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
