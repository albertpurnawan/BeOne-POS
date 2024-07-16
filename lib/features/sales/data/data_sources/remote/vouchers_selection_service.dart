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
  late VouchersSelectionModel voucher;

  VouchersSelectionApi(this._dio);

  Future<VouchersSelectionModel> checkVoucher(String serialno) async {
    try {
      SharedPreferences prefs = GetIt.instance<SharedPreferences>();
      token = prefs.getString('adminToken');

      List<POSParameterModel> pos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
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

      // log(response.toString());
      if (response.data == null) throw "Voucher not found";
      voucher = VouchersSelectionModel(
        docId: response.data['docid'],
        tpmt3Id: null,
        tovcrId: response.data['tovcr_id']['docid'],
        voucherAlias: response.data['tovcr_id']['remarks'],
        voucherAmount: response.data['tovcr_id']['voucheramount'],
        validFrom: DateTime.tryParse(response.data['tovcr_id']['validfrom'])!,
        validTo: DateTime.tryParse(response.data['tovcr_id']['validfrom'])!,
        serialNo: response.data['serialno'],
        voucherStatus: response.data['voucherstatus'],
        statusActive: response.data['statusactive'],
        minPurchase: response.data['tovcr_id']['minpurchase'],
        redeemDate: DateTime.now(),
        tinv2Id: "", // need Here
        type: response.data['tovcr_id']['type'],
      );

      return voucher;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> redeemVoucher(String serialno) async {
    try {
      SharedPreferences prefs = GetIt.instance<SharedPreferences>();
      token = prefs.getString('adminToken');

      List<POSParameterModel> pos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      url = pos[0].baseUrl;
      tostrId = pos[0].tostrId;

      final response = await _dio.put(
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

      return response.data;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
