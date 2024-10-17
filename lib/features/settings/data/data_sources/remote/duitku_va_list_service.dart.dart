import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/duitku_va_details.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DuitkuVAListApi {
  final Dio _dio;
  String? tenantId;
  String? tostrId;
  String? url;
  String? token;

  DuitkuVAListApi(this._dio);

  Future<List<DuitkuVADetailsModel>> getPaymentMethods() async {
    try {
      SharedPreferences prefs = GetIt.instance<SharedPreferences>();
      token = prefs.getString('adminToken');
      List<POSParameterModel> pos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      url = pos[0].baseUrl;
      tostrId = pos[0].tostrId;

      final response = await _dio.get("$url/tenant-va-list-by-store/$tostrId",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      final List<DuitkuVADetailsModel> models = (response.data['rows'] as List).map((item) {
        return DuitkuVADetailsModel.fromMapRemote(item);
      }).toList();
      return models;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
