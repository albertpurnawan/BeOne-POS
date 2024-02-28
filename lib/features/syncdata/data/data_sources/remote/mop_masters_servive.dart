import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:sqflite/sqflite.dart';

class MOPApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  MOPApi(this._dio);

  Future<List<MOPModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<MOPModel> allData = [];

      while (hasMoreData) {
        final response = await _dio.get(
          "$url/tenant-means-of-payment/all/?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        List<MOPModel> data =
            (response.data as List).map((e) => MOPModel.fromMap(e)).toList();
        // log(check.toString());
        allData.addAll(data);

        if (data.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<MOPModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-means-of-payment/docid/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log([response.data].toString());

      MOPModel datum = MOPModel.fromMap(response.data);

      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
