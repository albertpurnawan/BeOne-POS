import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';

class InvoiceHeaderApi {
  final Dio _dio;
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImludGVyZmFjaW5nQHNlc2EuY29tIiwiZ3RlbnRJZCI6ImI1NjNlZTc0LTAzZmQtNGVhMy1iNmE1LTBkYzA2MDdlZjhmYiIsInRvdXNySWQiOiJmYWIwNTZmYS1iMjA2LTQzNjAtOGMzNS01Njg0MDc2NTE4MjciLCJ0b3JvbElkIjoiM2I0ZDEyYzEtYjNmNi00ODQ0LThlMzEtMTk3YTM1ODc4MzdjIiwiaWF0IjoxNzEwNzI4MzA0LCJleHAiOjE3MTE5Mzc5MDR9.YSh19bRxVAhEAVjRPfn8VZtj4g2KJYsQKm_WZ4oUc6U";
  String url = "http://192.168.1.52:3001";

  InvoiceHeaderApi(this._dio);

  Future<List<InvoiceHeaderModel>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<InvoiceHeaderModel> allData = [];

      while (hasMoreData) {
        final response = await _dio.get(
          "$url/tenant-invoice?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );
        log(response.data[0].toString());

        List<InvoiceHeaderModel> data = (response.data as List)
            .map((e) => InvoiceHeaderModel.fromMapRemote(e))
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
      handleError(err);
      rethrow;
    }
  }

  Future<InvoiceHeaderModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-invoice/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log(response.data.toString());
      if (response.data == null) throw Exception('Null Data');

      InvoiceHeaderModel datum =
          InvoiceHeaderModel.fromMapRemote(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
