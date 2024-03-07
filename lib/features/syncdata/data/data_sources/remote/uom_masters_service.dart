import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/uom.dart';

class UoMApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  UoMApi(this._dio);

  Future<List<UomModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<UomModel> allData = [];

      while (hasMoreData) {
        final response = await _dio.get(
          "$url/tenant-master-unit-of-measurement?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        List<UomModel> data =
            (response.data as List).map((e) => UomModel.fromMap(e)).toList();
        allData.addAll(data);

        if (data.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }
      // log(allData[0].toString());

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<UomModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-master-unit-of-measurement/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log(response.data.toString());
      if (response.data == null) throw Exception('Null Data');

      UomModel datum = UomModel.fromMap(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
