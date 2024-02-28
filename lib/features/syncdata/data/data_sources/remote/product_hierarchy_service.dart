import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/features/sales/data/models/product_hierarchy.dart';

class ProductHierarchyApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  ProductHierarchyApi(this._dio);

  Future<List<ProductHierarchyModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<ProductHierarchyModel> allData = [];

      while (hasMoreData) {
        final response = await _dio.get(
          "$url/tenant-product-hierarchy?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<ProductHierarchyModel> data = (response.data as List)
            .map((e) => ProductHierarchyModel.fromMap(e))
            .toList();
        // log(check.toString());
        allData.addAll(data);

        if (data.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

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

  Future<ProductHierarchyModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-product-hierarchy/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log([response.data].toString());

      ProductHierarchyModel datum =
          ProductHierarchyModel.fromMap(response.data);

      return datum;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }
}