import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/down_payment_model.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownPaymentApi {
  final Dio _dio;
  String? tenantId;
  String? url;
  String? token;
  String dpItemCode = "";

  DownPaymentApi(this._dio);

  Future<List<DownPaymetModel>> fetchData(String customerCode) async {
    try {
      final ItemModel? dp = await GetIt.instance<AppDatabase>().itemsDao.getDownPayment();
      if (dp != null) {
        dpItemCode = dp.itemCode;
      }

      // String apiName = "API-OUTSTANDINGDP";
      // Map<String, dynamic> exeData = {};
      List<DownPaymetModel> allData = [];
      SharedPreferences prefs = GetIt.instance<SharedPreferences>();
      token = prefs.getString('adminToken');

      List<POSParameterModel> pos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      tenantId = pos[0].gtentId;
      url = pos[0].baseUrl;

      final resp = await _dio.get(
        "$url/tenant-get-balance-dp",
        queryParameters: {
          "custcode": customerCode,
          "itemcode": dpItemCode,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      log("response - ${resp.data['result']}");
      // final response = await _dio.get(
      //   "$url/tenant-custom-query/list",
      //   options: Options(
      //     headers: {
      //       'Authorization': 'Bearer $token',
      //     },
      //   ),
      // );

      // for (var api in response.data) {
      //   if (api["name"] == apiName) {
      //     exeData = {
      //       "docid": api["docid"],
      //       "parameter": [customerCode]
      //     };
      //   }
      // }

      // final resp = await _dio.post("$url/tenant-custom-query/execute",
      //     data: exeData,
      //     options: Options(headers: {
      //       'Authorization': 'Bearer $token',
      //     }));

      if (resp.data['result'].isNotEmpty) {
        log("--- Down Payment ---");
        log(resp.data['result'][0].toString());

        List<DownPaymetModel> data =
            (resp.data['result'] as List).map((e) => DownPaymetModel.fromMapRemote(e)).toList();
        allData.addAll(data);
      }

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
