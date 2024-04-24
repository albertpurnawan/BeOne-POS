import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/data/models/vouchers_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VouchersSelectionApi {
  final Dio _dio;
  String? url;
  String? tostrId;
  String? token;

  VouchersSelectionApi(this._dio);

  Future<VouchersSelectionModel> checkVoucher(String serialno) async {
    try {
      SharedPreferences prefs = GetIt.instance<SharedPreferences>();
      token = prefs.getString('adminToken');

      List<POSParameterModel> pos =
          await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      url = pos[0].baseUrl;
      tostrId = pos[0].tostrId;

      final response = await _dio.get(
        "$url/tenant-check-register-voucher",
        queryParameters: {
          'serial_no': serialno,
          'tostrId': tostrId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      log("${response.data}");
      return response.data;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
