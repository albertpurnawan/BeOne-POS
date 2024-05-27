import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/cash_register.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashRegisterApi {
  final Dio _dio;
  String? tenantId;
  String? storeId;
  String? url;
  String? token;

  CashRegisterApi(this._dio);

  Future<List<CashRegisterModel>> initializeData() async {
    try {
      String apiName = "API-TOCSR";
      Map<String, dynamic> exeData = {};
      List<CashRegisterModel> allData = [];
      SharedPreferences prefs = GetIt.instance<SharedPreferences>();
      token = prefs.getString('adminToken');
      String date = "2000-01-01 00:00:00";

      List<POSParameterModel> pos =
          await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      tenantId = pos[0].gtentId;
      storeId = pos[0].tostrId;
      url = pos[0].baseUrl;

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
            "parameter": [
              tenantId,
              date,
              date,
              storeId,
            ]
          };
        }
      }

      final resp = await _dio.post("$url/tenant-custom-query/execute",
          data: exeData,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));

      if (resp.data['data'].isNotEmpty) {
        log("--- Cash Register ---");
        log(resp.data['data'][0].toString());

        List<CashRegisterModel> data = (resp.data['data'] as List)
            .map((e) => CashRegisterModel.fromMapRemote(e))
            .toList();
        allData.addAll(data);
      }

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
