import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/resources/data_sources_enum.dart';
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
            .map((e) =>
                ItemCategoryModel.fromMapByDataSource(DataSource.local, e))
            .toList();
        allData.addAll(data);

        if (data.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }
      // log(allData[0].toString());
      // for (var element in [allData[0]]) {
      //   element.forEach((key, value) {
      //     log('$key: ${value.runtimeType} $value');
      //   });
      // }

      return allData;
    } catch (err) {
      print('Error: $err');
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
      // log([response.data].toString());

      ItemCategoryModel datum = ItemCategoryModel.fromMapByDataSource(
          DataSource.local, response.data);

      return datum;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }
}
