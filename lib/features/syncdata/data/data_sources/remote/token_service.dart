// ignore_for_file: public_member_api_docs, sort_constructors_first
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
      final response = await _dio.get("$url/auth/login", data: {
        "email": emailAdmin,
        "password": passwordAdmin,
      });
      log(response.data);
      return response.data;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
