import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/currency.dart';

class CurrencyApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  CurrencyApi(this._dio);

  Future<List<CurrencyModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<CurrencyModel> allData = [];

      while (hasMoreData) {
        final response = await _dio.get(
          "$url/tenant-master-currency?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        List<CurrencyModel> data = (response.data as List)
            .map((e) => CurrencyModel.fromMap(e))
            .toList();
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

  Future<CurrencyModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-master-currency/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log(response.data.toString());
      if (response.data == null) throw Exception('Null Data');

      CurrencyModel datum = CurrencyModel.fromMap(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
