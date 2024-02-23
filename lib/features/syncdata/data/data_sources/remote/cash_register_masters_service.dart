import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class CashRegisterApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;
  String url = "http://192.168.1.34:3001";

  CashRegisterApi(this.db);

  Future<List<Map<String, dynamic>>> fetchCashRegistersData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allCashRegisters = [];

      while (hasMoreData) {
        final response = await dio.get(
          "$url/tenant-cash-register?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<Map<String, dynamic>> cashRegistersData =
            response.data.cast<Map<String, dynamic>>();
        allCashRegisters.addAll(cashRegistersData);

        if (cashRegistersData.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }

      return allCashRegisters;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSingleCashRegister(String docid) async {
    try {
      final response = await dio.get(
        "$url/tenant-cash-register/$docid",
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
