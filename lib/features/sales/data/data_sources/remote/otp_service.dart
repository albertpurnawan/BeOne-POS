import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';

class OTPServiceAPi {
  final Dio _dio;
  String? token;
  String? otpChannel;

  OTPServiceAPi(this._dio);

  Future<Map<String, dynamic>> createSendOTP(BuildContext context, double? amount) async {
    try {
      log("CREATE & SEND OTP - $amount");
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

      final cashierMachine = await GetIt.instance<AppDatabase>().cashRegisterDao.readByDocId(topos[0].tocsrId!, null);
      final shift = await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.readLastValue();
      final cashierName = await GetIt.instance<AppDatabase>().userDao.readByDocId(shift!.tousrId!, null);

      for (final spv in spvList) {
        Map<String, dynamic> dataToSend = {};
        if (amount != null) {
          final discount = Helpers.parseMoney(amount);
          dataToSend = {
            "uuid": "c3ba4678-bacf-4f60-9d2d-405f7bf8deed", // uuid master channel
            "channelId": otpChannel, // uuid smtp
            "Destination": spv['email'],
            "Expired": formattedExpired,
            "RequestTimestamp": formattedDateTime,
            "isUsed": false,
            "additionalInfo": {
              "StoreName": store.storeName,
              "CashierId": (cashierMachine!.description == "") ? cashierMachine.idKassa : cashierMachine.description,
              "CashierName": cashierName!.username,
              "DiscountAmmount": discount,
            }
          };
        } else {
          dataToSend = {
            "uuid": "c3ba4678-bacf-4f60-9d2d-405f7bf8deed", // uuid master channel
            "channelId": otpChannel, // uuid smtp
            "Destination": spv['email'],
            "Expired": formattedExpired,
            "RequestTimestamp": formattedDateTime,
            "isUsed": false,
            "additionalInfo": {
              "StoreName": store.storeName,
              "CashierId": (cashierMachine!.description == "") ? cashierMachine.idKassa : cashierMachine.description,
              "CashierName": cashierName!.username
            }
          };
        }
        log("Data2Send for ${spv['email']}: ${jsonEncode(dataToSend)}");

        Response response = await _dio.post(
          url,
          data: dataToSend,
          options: options,
        );

        log("Response for ${spv['email']}: ${response.statusCode}");

        return response.data;
      }
      throw "No supervisors to send OTP to.";
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
        "requesterId": "Top-Golf",
      }; // need to change the requesterId
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
      return {"errpr": e.toString()};
    }
  }
}
