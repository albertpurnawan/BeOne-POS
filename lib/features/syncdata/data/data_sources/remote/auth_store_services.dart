// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/authentication_store.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStoreApi {
  final Dio _dio;
  String? url;
  String? token;
  String? tenantId;
  String? tostrId;

  AuthStoreApi(this._dio);

  Future<List<AuthStoreModel>> fetchData(String lastSync) async {
    try {
      String apiName = "API-TASTR";
      Map<String, dynamic> exeData = {};
      List<AuthStoreModel> allData = [];
      SharedPreferences prefs = GetIt.instance<SharedPreferences>();
      token = prefs.getString('adminToken');

      List<POSParameterModel> pos =
          await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      tenantId = pos[0].gtentId;
      tostrId = pos[0].tostrId;
      url = pos[0].baseUrl;

      final response = await _dio.get(
        "$url/tenant-custom-query/list",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      for (var api in response.data) {
        if (api["name"] == apiName) {
          exeData = {
            "docid": api["docid"],
            "parameter": [
              tenantId,
              lastSync,
              lastSync,
              tostrId,
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
        log("--- Auth Store ---");
        log(resp.data['data'][0].toString());

        List<AuthStoreModel> data = (resp.data['data'] as List)
            .map((e) => AuthStoreModel.fromMap(e))
            .toList();
        allData.addAll(data);
      }

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
