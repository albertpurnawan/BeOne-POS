import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashierBalanceTransactionApi {
  final Dio _dio;
  String? tenantId;
  String? storeId;
  String? url;
  String? token;
  final SharedPreferences prefs;

  CashierBalanceTransactionApi(this._dio, this.prefs);

  Future<void> sendTransactions(CashierBalanceTransactionModel tcsr1) async {
    try {
      token = prefs.getString('adminToken');
      List<POSParameterModel> pos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      url = pos[0].baseUrl;

      final tcsr2 = await GetIt.instance<AppDatabase>().moneyDenominationDao.readByTcsr1Id(tcsr1.docId, null);
      List<Map<String, dynamic>?> tcsr2List = tcsr2.map((data) {
        if (data != null) {
          return {"lembaran": data.nominal.toString(), "qty": data.count};
        }
      }).toList();

      final dataToSend = {
        "docnum": tcsr1.docNum,
        "opendate": '${tcsr1.openDate.toIso8601String()}Z',
        "opentime": '${tcsr1.openTime.toIso8601String()}Z',
        "calcdate": '${tcsr1.calcDate.toIso8601String()}Z',
        "calctime": '${tcsr1.calcTime.toIso8601String()}Z',
        "closedate": '${tcsr1.closeDate.toIso8601String()}Z',
        "closetime": '${tcsr1.closeTime.toIso8601String()}Z',
        "timezone": tcsr1.timezone,
        "tocsr_id": tcsr1.tocsrId,
        "tousr_id": tcsr1.tousrId,
        "openvalue": tcsr1.openValue,
        "calcvalue": tcsr1.calcValue,
        "closevalue": tcsr1.closeValue,
        "cashvalue": tcsr1.cashValue,
        "openby_id": tcsr1.openedbyId,
        "closeby_id": tcsr1.closedbyId,
        "refpos": tcsr1.refpos,
        "detail_cash_register": tcsr2List,
        "closedaproveby_id": tcsr1.closedApproveById,
      };
      log("dataToSend - ${jsonEncode(dataToSend)}");
      final response = await _dio.post("$url/tenant-cashier-balance-transaction",
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
