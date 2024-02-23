import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class CustomerGroupApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;
  String url = "http://192.168.1.34:3001";

  CustomerGroupApi(this.db);

  Future<List<Map<String, dynamic>>> fetchCustomerGroupsData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allCustomerGroups = [];

      while (hasMoreData) {
        final response = await dio.get(
          "$url/tenant-customer-group?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<Map<String, dynamic>> customerGroupsData =
            response.data.cast<Map<String, dynamic>>();
        allCustomerGroups.addAll(customerGroupsData);

        if (customerGroupsData.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      return allCustomerGroups;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSingleCustomerGroup(String docid) async {
    try {
      final response = await dio.get(
        "$url/tenant-customer-group/$docid",
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
