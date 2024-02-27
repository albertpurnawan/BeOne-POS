import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/features/sales/data/models/item_master.dart';

class ItemsApi {
  final Dio _dio;
  String token = Constant.token;
  String storeId = Constant.storeId;
  String url = Constant.url;

  ItemsApi(this._dio);

  Future<List<ItemMasterModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<ItemMasterModel> allData = [];

      while (hasMoreData) {
        final response = await _dio.get(
          "$url/tenant-item-master/hierarchy?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<ItemMasterModel> data = (response.data as List)
            .map((e) => ItemMasterModel.fromMap(e))
            .toList();
        allData.addAll(data);

        if (data.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      return allData;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<ItemMasterModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-item-master/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log([response.data].toString());

      ItemMasterModel datum = ItemMasterModel.fromMap(response.data);

      return datum;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }
}
