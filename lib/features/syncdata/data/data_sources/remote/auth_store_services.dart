// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStoreApi {
  final Dio _dio;
  String? url;
  String? token;
  String? tostrId;
  String? username;
  String? password;

  AuthStoreApi(this._dio);

  Future<String> authUser(String username, String password) async {
    try {
      String apiName = "API-STOREAUTH";
      Map<String, dynamic> exeData = {};
      String check;
      SharedPreferences prefs = GetIt.instance<SharedPreferences>();
      token = prefs.getString('adminToken');

      List<POSParameterModel> pos =
          await GetIt.instance<AppDatabase>().posParameterDao.readAll();
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
            "parameter": [tostrId, username, password]
          };
        }
      }

      final resp = await _dio.post("$url/tenant-custom-query/execute",
          data: exeData,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));

      if (resp.statusMessage == 'OK') {
        check = "Success Auth";
      } else {
        check = "Auth Failed";
      }

      return check;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
