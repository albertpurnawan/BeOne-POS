import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/mop_adjustment_detail.dart';
import 'package:pos_fe/features/sales/data/models/mop_adjustment_header.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MOPAdjustmentService {
  final Dio _dio;
  String? tenantId;
  String? storeId;
  String? url;
  String? token;
  final SharedPreferences prefs;

  MOPAdjustmentService(this._dio, this.prefs);

  Future<void> sendMOPAdjustment(MOPAdjustmentHeaderModel tmpad,
      List<MOPAdjustmentDetailModel> mpad1List) async {
    try {
      log("SEND MOP ADJUSTMENT");
      token = prefs.getString('adminToken');
      List<POSParameterModel> pos =
          await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      url = pos[0].baseUrl;
      DateTime now = DateTime.now();

      final dataToSend = {
        "docnum": tmpad.docNum,
        "docdate": '${tmpad.docDate.toIso8601String()}Z',
        "doctime": '${tmpad.docTime.toIso8601String()}Z',
        "timezone": tmpad.timezone,
        "posted": 1,
        "postdate": '${now.toIso8601String()}Z',
        "posttime": '${now.toIso8601String()}Z',
        "remarks": tmpad.remarks,
        "tostr_id": pos[0].tostrId,
        "detail_adjustment": [
          {"tpmt3_id": mpad1List[0].tpmt3Id, "amount": mpad1List[0].amount},
          {"tpmt3_id": mpad1List[1].tpmt3Id, "amount": mpad1List[1].amount}
        ]
      };
      log("dataToSend - $dataToSend");
      final response = await _dio.post("$url/tenant-mop-adjustment",
          data: dataToSend,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));

      log("${response.data['description']}");
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }
}
