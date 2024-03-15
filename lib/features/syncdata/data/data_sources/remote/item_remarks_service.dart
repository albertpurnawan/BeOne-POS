import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/item_remarks.dart';

class ItemRemarksApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  ItemRemarksApi(this._dio);

  Future<List<ItemRemarksModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<ItemRemarksModel> allData = [];

      final response = await _dio.get(
        "$url/tenant-custom-query/list",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final exeData = {
        "docid": response.data[26]['docid'],
        "parameter": ["878694e6-fdf4-49a7-82e3-d0facb685741"]
      };
      // log(exeData.toString());

      final resp = await _dio.post("$url/tenant-custom-query/execute",
          data: exeData,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));

      if (resp.data['data'].isNotEmpty) {
        log(resp.data['data'][0].toString());

        List<ItemRemarksModel> data = (resp.data['data'] as List)
            .map((e) => ItemRemarksModel.fromMapRemote(e))
            .toList();
        allData.addAll(data);
      }

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<ItemRemarksModel> fetchSingleData(String docid) async {
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

      ItemRemarksModel datum = ItemRemarksModel.fromMap(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
