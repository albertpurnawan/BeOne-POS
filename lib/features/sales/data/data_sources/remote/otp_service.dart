import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPServiceAPi {
  final Dio _dio;
  String url = "http://110.239.68.248:7070/api/otp/send-mailer";
  String? token;
  final SharedPreferences prefs;

  OTPServiceAPi(this._dio, this.prefs);

  Future<String> createSendOTP() async {
    try {
      log("CREATE & SEND OTP");
      final String? cashier = prefs.getString('username');
      log(cashier!);
      final options = Options(headers: {"Content-Type": "application/json"});
      final formatter = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
      final formattedExpired =
          formatter.format(DateTime.now().add(const Duration(hours: 1)));
      final formattedDateTime = formatter.format(DateTime.now());

      final dataToSend = {
        "channelId": 2, //uuid dari channel
        "Destination": "mefava2820@exeneli.com", // email from tastr->tousr
        "Expired": formattedExpired,
        "RequestTimestamp": formattedDateTime,
        "Requester": cashier,
        "isIssued": true,
        "isUsed": false
      };
      log(url);
      log("Data2Send: ${jsonEncode(dataToSend)}");
      Response response = await _dio.post(
        url,
        data: dataToSend,
        options: options,
      );
      log(response.data['KodeOTP']);
      return response.data['KodeOTP'];
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }
}
