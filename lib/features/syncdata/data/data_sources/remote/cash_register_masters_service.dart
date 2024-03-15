import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/cash_register.dart';

class CashRegisterApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  CashRegisterApi(this._dio);

  Future<List<CashRegisterModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<CashRegisterModel> allData = [];

      final response = await _dio.get(
        "$url/tenant-custom-query/list",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final exeData = {
        "docid": response.data[17]['docid'],
        "parameter": ["878694e6-fdf4-49a7-82e3-d0facb685741"]
      };
      // log(exeData.toString());

      final resp = await _dio.post("$url/tenant-custom-query/execute",
          data: exeData,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      log(resp.data['data'].toString());

      List<CashRegisterModel> data = (resp.data['data'] as List)
          .map((e) => CashRegisterModel.fromMapRemote(e))
          .toList();
      allData.addAll(data);

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<CashRegisterModel> fetchSingleData(String docid) async {
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

      CashRegisterModel datum = CashRegisterModel.fromMap(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
