import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class CustomerApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;
  String url = "http://192.168.1.34:3001";

  CustomerApi(this.db);

  Future<List<Map<String, dynamic>>> fetchCustomersData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allCustomers = [];

      while (hasMoreData) {
        final response = await dio.get(
          "$url/tenant-customer?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<Map<String, dynamic>> customersData =
            response.data.cast<Map<String, dynamic>>();
        allCustomers.addAll(customersData);

        if (customersData.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      return allCustomers;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSingleCustomer(String docid) async {
    try {
      final response = await dio.get(
        "$url/tenant-customer/$docid",
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
