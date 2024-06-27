import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPServiceAPi {
  final Dio _dio;
  String? token;
  final SharedPreferences prefs;

  OTPServiceAPi(this._dio, this.prefs);

  Future<Map<String, dynamic>> createSendOTP() async {
    try {
      log("CREATE & SEND OTP");
      String url = "http://110.239.68.248:7070/api/otp/send-mailer";
      final spv =
          await GetIt.instance<AppDatabase>().authStoreDao.readEmailByTousrId();

      final options = Options(headers: {"Content-Type": "application/json"});
      final formatter = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
      final formattedExpired = formatter
          .format(DateTime.now().toUtc().add(const Duration(hours: 1)));
      final formattedDateTime = formatter.format(DateTime.now().toUtc());

      final dataToSend = {
        "uuid": "c3ba4678-bacf-4f60-9d2d-405f7bf8deed", // uuid master channel
        "channelId": "cc985aff-654d-41fb-84d0-2f2eea388729", // uuid smtp
        "Destination": spv![0]['email'],
        "Expired": formattedExpired,
        "RequestTimestamp": formattedDateTime,
        "isUsed": false
      };
      log("Data2Send: ${jsonEncode(dataToSend)}");

      Response response = await _dio.post(
        url,
        data: dataToSend,
        options: options,
      );
      log("response: $response");

      log("response otp $response");

      return response.data;
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<String> validateOTP(String otp, String requester) async {
    try {
      log("VALIDATE OTP");
      String url = "http://110.239.68.248:7070/api/otp/submit";
      final options = Options(headers: {"Content-Type": "application/json"});

      final dataToSend = {
        "otp": otp,
        "requesterId": "Top-Golf",
      }; // need to change the requesterId
      // log("Data2Send: ${jsonEncode(dataToSend)}");

      Response response = await _dio.post(
        url,
        data: dataToSend,
        options: options,
      );

      return "${response.statusCode}";
    } catch (e) {
      handleError(e);
      return e.toString();
    }
  }
}
