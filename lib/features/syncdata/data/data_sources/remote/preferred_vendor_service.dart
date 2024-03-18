import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/preferred_vendor.dart';

class PreferredVendorApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  PreferredVendorApi(this._dio);

  Future<List<PreferredVendorModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<PreferredVendorModel> allData = [];

      final response = await _dio.get(
        "$url/tenant-custom-query/list",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final exeData = {
        "docid": response.data[29]['docid'],
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

        List<PreferredVendorModel> data = (resp.data['data'] as List)
            .map((e) => PreferredVendorModel.fromMapRemote(e))
            .toList();
        allData.addAll(data);
      }

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<PreferredVendorModel> fetchSingleData(String docid) async {
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

      PreferredVendorModel datum = PreferredVendorModel.fromMap(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
