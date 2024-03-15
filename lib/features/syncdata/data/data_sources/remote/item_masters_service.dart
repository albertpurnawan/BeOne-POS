import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/item_master.dart';

class ItemMasterApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  ItemMasterApi(this._dio);

  Future<List<ItemMasterModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<ItemMasterModel> allData = [];

      final response = await _dio.get(
        "$url/tenant-custom-query/list",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final exeData = {
        "docid": response.data[23]['docid'],
        "parameter": ["878694e6-fdf4-49a7-82e3-d0facb685741"]
      };
      // log(exeData.toString());

      final resp = await _dio.post("$url/tenant-custom-query/execute",
          data: exeData,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      log(resp.data['data'][0].toString());

      List<ItemMasterModel> data = (resp.data['data'] as List)
          .map((e) => ItemMasterModel.fromMapRemote(e))
          .toList();
      allData.addAll(data);

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<ItemMasterModel> fetchSingleData(String docid) async {
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

      ItemMasterModel datum = ItemMasterModel.fromMap(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
