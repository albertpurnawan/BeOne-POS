import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/product_hierarchy_master.dart';

class ProductHierarchyMasterApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  ProductHierarchyMasterApi(this._dio);

  Future<List<ProductHierarchyMasterModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<ProductHierarchyMasterModel> allData = [];

      while (hasMoreData) {
        final response = await _dio.get(
          "$url/tenant-product-hierarchy-master?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<ProductHierarchyMasterModel> data = (response.data as List)
            .map((e) => ProductHierarchyMasterModel.fromMapRemote(e))
            .toList();
        // log(check.toString());
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

  Future<ProductHierarchyMasterModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-product-hierarchy-master/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log(response.data.toString());

      if (response.data == null) throw Exception('Null Data');

      ProductHierarchyMasterModel datum =
          ProductHierarchyMasterModel.fromMapRemote(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
