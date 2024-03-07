import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/pricelist_period.dart';

class PricelistPeriodApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;
  String topln_id = '3d355ebf-ae71-4892-b09c-bdc8ae8f7331';

  PricelistPeriodApi(this._dio);

  Future<List<PricelistPeriodModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<PricelistPeriodModel> allData = [];

      while (hasMoreData) {
        final response = await _dio.get(
          "$url/tenant-pricelist-period?page=$page&topln_id=$topln_id",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<PricelistPeriodModel> data = (response.data as List)
            .map((e) => PricelistPeriodModel.fromMapRemote(e))
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

  Future<PricelistPeriodModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-pricelist-period/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log(response.data.toString());

      PricelistPeriodModel datum =
          PricelistPeriodModel.fromMapRemote(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
