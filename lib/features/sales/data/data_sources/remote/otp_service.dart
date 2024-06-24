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
      final String? cashier = prefs.getString('username');
      final spv =
          await GetIt.instance<AppDatabase>().authStoreDao.readEmailByTousrId();

      final options = Options(headers: {"Content-Type": "application/json"});
      final formatter = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
      final formattedExpired = formatter
          .format(DateTime.now().toUtc().add(const Duration(hours: 1)));
      final formattedDateTime = formatter.format(DateTime.now().toUtc());

      final dataToSend = {
        "channelId": "cc985aff-654d-41fb-84d0-2f2eea388729", //uuid dari channel
        "Destination": spv![0]['email'],
        "Expired": formattedExpired,
        "RequestTimestamp": formattedDateTime,
        "Requester": cashier
      };
      // log("Data2Send: ${jsonEncode(dataToSend)}");

      Response response = await _dio.post(
        url,
        data: dataToSend,
        options: options,
      );

      return response.data;
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<String> validateOTP(
    String otp,
  ) async {
    try {
      log("VALIDATE OTP");
      String url = "http://110.239.68.248:7070/api/otp/submit";
      final options = Options(headers: {"Content-Type": "application/json"});
      final String? cashier = prefs.getString('username');

      final dataToSend = {"otp": otp, "requesterId": cashier};
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
