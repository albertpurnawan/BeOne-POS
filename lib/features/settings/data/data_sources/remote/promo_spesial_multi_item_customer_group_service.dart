import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/data/models/promo_spesial_multi_item_customer_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromoSpesialMultiItemCustomerGroupApi {
  final Dio _dio;
  String? tenantId;
  String? storeId;
  String? url;
  String? token;

  PromoSpesialMultiItemCustomerGroupApi(this._dio);

  Future<List<PromoSpesialMultiItemCustomerGroupModel>> fetchData(String lastSync) async {
    try {
      String apiName = "API-TPSM4";
      Map<String, dynamic> exeData = {};
      List<PromoSpesialMultiItemCustomerGroupModel> allData = [];
      SharedPreferences prefs = GetIt.instance<SharedPreferences>();
      token = prefs.getString('adminToken');

      List<POSParameterModel> pos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      tenantId = pos[0].gtentId;
      storeId = "%%";
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
        log("--- PROMO SPESIAL MULTI ITEM - CUSTOMER GROUP ---");
        log(resp.data['data'][0].toString());

        // resp.data['data'][0].forEach((key, value) {
        //   print('$key: ${value.runtimeType}');
        // });

        List<PromoSpesialMultiItemCustomerGroupModel> data =
            (resp.data['data'] as List).map((e) => PromoSpesialMultiItemCustomerGroupModel.fromMapRemote(e)).toList();
        allData.addAll(data);
      }

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
