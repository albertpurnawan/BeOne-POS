import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class ItemCategoryApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;
  String url = "http://192.168.1.34:3001";

  ItemCategoryApi(this.db);

  Future<List<Map<String, dynamic>>> fetchItemCategoriesData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allItemCategories = [];

      while (hasMoreData) {
        final response = await dio.get(
          "$url/tenant-product-category?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<Map<String, dynamic>> itemCategoriesData =
            response.data.cast<Map<String, dynamic>>();
        allItemCategories.addAll(itemCategoriesData);

        if (itemCategoriesData.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      return allItemCategories;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSingleItemCategory(String docid) async {
    try {
      final response = await dio.get(
        "$url/tenant-product-category/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log([response.data].toString());

      return [response.data];
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }
}
