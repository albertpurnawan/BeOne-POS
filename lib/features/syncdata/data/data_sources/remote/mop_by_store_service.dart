import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/mop_by_store.dart';

class MOPByStoreApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  MOPByStoreApi(this._dio);

  Future<List<MOPByStoreModel>> fetchData() async {
    try {
      String apiName = "API-MOPBYSTORE";
      Map<String, dynamic> exeData = {};
      List<MOPByStoreModel> allData = [];

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
          exeData = {
            "docid": api["docid"],
            "parameter": ["e24bd658-bfb6-404f-b867-3e294b8d5b0b"]
          };
        }
      }

      final resp = await _dio.post("$url/tenant-custom-query/execute",
          data: exeData,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));

      if (resp.data['data'].isNotEmpty) {
        log("--- MOP BY STORE ---");
        log(resp.data['data'][0].toString());

        List<MOPByStoreModel> data = (resp.data['data'] as List)
            .map((e) => MOPByStoreModel.fromMapRemote(e))
            .toList();
        allData.addAll(data);
      }

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<MOPByStoreModel> fetchSingleData(String docid) async {
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

      MOPByStoreModel datum = MOPByStoreModel.fromMap(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
