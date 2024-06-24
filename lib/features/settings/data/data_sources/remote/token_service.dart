// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';

class TokenApi {
  final Dio _dio;

  TokenApi(
    this._dio,
  );

  Future<String?> getToken(
      String url, String emailAdmin, String passwordAdmin) async {
    try {
      Map<String, dynamic> formData = {
        "email": emailAdmin,
        "password": passwordAdmin,
      };

      final response = await _dio.post("$url/auth/login",
          data: formData,
          options: Options(
            validateStatus: (_) => true,
          ));

      return response.data['token'];
    } catch (err, s) {
      debugPrintStack(stackTrace: s);
      handleError(err);
      rethrow;
    }
  }
}
