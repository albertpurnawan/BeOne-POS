import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class ItemsApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;

  ItemsApi(this.db);

  Future<List<Map<String, dynamic>>> fetchItemsData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allItems = [];

      while (hasMoreData) {
        final response = await dio.get(
          "http://192.168.1.34:3001/tenant-item-master?page=$page",
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

      // log(response.data[0].toString());
      // log(users[0].toString());

      return allItems;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSingleItemData(String docid) async {
    try {
      final response = await dio.get(
        "http://192.168.1.34:3001/tenant-item-master/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // final Items user = Items.fromJson(response.data);

      // print('User: $user');

      return [response.data];
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }
}
