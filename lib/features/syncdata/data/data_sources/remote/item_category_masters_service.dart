import 'package:dio/dio.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/features/sales/data/models/item_category.dart';

class ItemCategoryApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  ItemCategoryApi(this._dio);

  Future<List<ItemCategoryModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<ItemCategoryModel> allData = [];

      while (hasMoreData) {
        final response = await _dio.get(
          "$url/tenant-product-category?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        List<ItemCategoryModel> data = (response.data as List)
            .map((e) => ItemCategoryModel.fromMapRemote(e))
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

  Future<ItemCategoryModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-product-category/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log(response.data.toString());

      if (response.data == null) throw Exception('Null Data');

      ItemCategoryModel datum = ItemCategoryModel.fromMapRemote(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
