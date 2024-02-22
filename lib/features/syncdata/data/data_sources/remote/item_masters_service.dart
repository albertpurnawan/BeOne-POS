import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class ItemsApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;
  String storeId = Constant.storeId;
  String url = "http://192.168.1.34:3001";

  ItemsApi(this.db);

  Future<List<Map<String, dynamic>>> fetchItemsData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allItems = [];

      while (hasMoreData) {
        final response = await dio.get(
          "$url/tenant-item-by-store/?page=$page&store_id=$storeId",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<Map<String, dynamic>> itemsData =
            response.data.cast<Map<String, dynamic>>();
        allItems.addAll(itemsData);

        if (itemsData.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }
      // log(allItems.toString());

      return allItems;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSingleItem(String docid) async {
    try {
      final response = await dio.get(
        "$url/tenant-item-master/$docid",
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
