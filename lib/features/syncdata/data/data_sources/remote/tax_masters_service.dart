import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/tax_master.dart';

class TaxMasterApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  TaxMasterApi(this._dio);

  Future<List<TaxMasterModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<TaxMasterModel> allData = [];

      final response = await _dio.get(
        "$url/tenant-custom-query/list",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final exeData = {"docid": response.data[10]['docid'], "parameter": []};
      // log(exeData.toString());

      final resp = await _dio.post("$url/tenant-custom-query/execute",
          data: exeData,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      log(resp.data['data'].toString());

      List<TaxMasterModel> data = (resp.data['data'] as List)
          .map((e) => TaxMasterModel.fromMapRemote(e))
          .toList();
      allData.addAll(data);

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<TaxMasterModel> fetchSingleData(String docid) async {
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

      TaxMasterModel datum = TaxMasterModel.fromMap(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
