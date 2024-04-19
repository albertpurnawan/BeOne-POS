// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';

class TokenApi {
  final Dio _dio;

  TokenApi(
    this._dio,
  );

  Future<String> getToken(
      String url, String emailAdmin, String passwordAdmin) async {
    try {
      log(url);
      log(emailAdmin);
      log(passwordAdmin);
      var formData = FormData.fromMap({
        'data': json.encode({
          'email': emailAdmin,
          'password': 'passwordAdmin',
        })
      });

      final response = await _dio.get("$url/auth/login", data: formData);
      log(response.data);
      return response.data;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
