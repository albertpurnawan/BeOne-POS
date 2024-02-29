import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/item_by_store.dart';

class ItemByStoreApi {
  final Dio _dio;
  String token = Constant.token;
  String storeId = Constant.storeId;
  String url = Constant.url;

  ItemByStoreApi(this._dio);

  Future<List<ItemByStoreModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<ItemByStoreModel> allData = [];

      while (hasMoreData) {
        final response = await _dio.get(
          "$url/tenant-item-by-store/?page=$page&store_id=$storeId",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        List<ItemByStoreModel> data = (response.data as List)
            .map((e) => ItemByStoreModel.fromMapRemote(e))
            .toList();
        allData.addAll(data);

        if (data.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }
      log(allData[0].toString());
      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<ItemByStoreModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-item-by-store/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // response.data.forEach((key, value) {
      //   log('$key: ${value.runtimeType} $value');
      // });

      if (response.data == null) throw Exception('Null Data');

      ItemByStoreModel datum = ItemByStoreModel.fromMapRemote(response.data);
      log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
