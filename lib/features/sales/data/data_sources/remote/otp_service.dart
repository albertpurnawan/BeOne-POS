import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';

class OTPServiceAPi {
  final Dio _dio;
  String? token;
  String? otpChannel;

  OTPServiceAPi(this._dio);

  Future<Map<String, dynamic>> createSendOTP(
      BuildContext context, Map<String, String>? payload, String? subject, String? emailBody) async {
    Response? response;

    try {
      log("CREATE & SEND OTP");
      final topos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      final store = await GetIt.instance<AppDatabase>().storeMasterDao.readByDocId(topos[0].tostrId!, null);

      if (store == null) {
        throw "No Store Found";
      }

      if (store.otpChannel == null || store.otpUrl == null) {
        SnackBarHelper.presentFailSnackBar(context, "OTP data not found. Please check Store data");
        throw "OTP data not found. Please check Store data.";
      }

      otpChannel = store.otpChannel;
      String url = "${store.otpUrl}/api/otp/send-mailer";
      final spvList = await GetIt.instance<AppDatabase>().authStoreDao.readEmailByTousrId();
      log("spvList - $spvList");
      if (spvList == null || spvList.isEmpty) throw "Approver not found";

      final options = Options(headers: {"Content-Type": "application/json"});
      final formatter = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
      final formattedExpired = formatter.format(DateTime.now().toUtc().add(const Duration(hours: 1)));
      final formattedDateTime = formatter.format(DateTime.now().toUtc());

      for (final spv in spvList) {
        Map<String, dynamic> dataToSend = {};

        const String greeting = "Hi {destination}, your OTP CODE is {otp}.";

        dataToSend = {
          "uuid": "c3ba4678-bacf-4f60-9d2d-405f7bf8deed", // uuid master channel
          "channelId": otpChannel, // uuid smtp
          "Destination": spv['email'],
          "Expired": formattedExpired,
          "RequestTimestamp": formattedDateTime,
          "isUsed": false,
          "additionalInfo": {},
          if (emailBody != null) "customEmailText": "$greeting\n$emailBody",
          if (subject != null) "customSubject": subject,
        };

        log("Data2Send for ${spv['email']}: ${jsonEncode(dataToSend)}");

        response = await _dio.post(
          url,
          data: dataToSend,
          options: options,
        );

        log("Response for ${spv['email']}: ${response.statusCode}");
      }
      return response?.data;
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<Map<String, String>> validateOTP(String otp, String requester) async {
    try {
      // log("VALIDATE OTP");
      final topos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      final store = await GetIt.instance<AppDatabase>().storeMasterDao.readByDocId(topos[0].tostrId!, null);
      String url = "${store!.otpUrl}/api/otp/submit";
      final options = Options(headers: {"Content-Type": "application/json"});

      final dataToSend = {
        "otp": otp,
        "requesterId": requester,
      };
      // log("Data2Send: ${jsonEncode(dataToSend)}");

      Response response = await _dio.post(
        url,
        data: dataToSend,
        options: options,
      );
      log("responseValidate - $response");

      return {"status": "${response.statusCode}", "approver": "${response.data['data']?['Destination']}"};
    } catch (e) {
      handleError(e);
      return {"error": e.toString()};
    }
  }
}
