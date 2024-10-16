import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/data/models/return_receipt_remote.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReturnApi {
  final Dio _dio;

  ReturnApi(this._dio);

  Future<ReturnReceiptRemoteModel> fetchData(String invoiceDocNum, String storeCode) async {
    try {
      const String apiName = "API-REFUNDINVOICE";
      Map<String, dynamic> exeData = {};
      final ReturnReceiptRemoteModel returnReceiptModel;
      SharedPreferences prefs = GetIt.instance<SharedPreferences>();
      final String? token = prefs.getString('adminToken');

      POSParameterModel? pos = (await GetIt.instance<AppDatabase>().posParameterDao.readAll()).firstOrNull;
      if (pos == null) throw "POS Parameter not found when fetching invoice";
      if (pos.baseUrl == null || pos.tostrId == null) throw "Invalid POS Parameter when fetching invoice";
      final String url = pos.baseUrl!;

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
            "parameter": [invoiceDocNum, storeCode]
          };

          break;
        }
      }

      final resp = await _dio.post("$url/tenant-custom-query/execute",
          data: exeData,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      if (resp.data['data'] == null) throw "Invalid data fetched";
      if (resp.data['data'].isEmpty) throw "Invoice not found";
      log("--- Return ---");
      log(resp.data['data'][0].toString());

      returnReceiptModel = ReturnReceiptRemoteModel.fromMapRemote(resp.data);

      return returnReceiptModel;
    } catch (err, s) {
      handleError(err);
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
}
