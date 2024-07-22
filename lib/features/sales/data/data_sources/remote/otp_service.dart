import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/core/utilities/helpers.dart';

class OTPServiceAPi {
  final Dio _dio;
  String? token;
  String? otpChannel;

  OTPServiceAPi(this._dio);

  Future<Map<String, dynamic>> createSendOTP(double? amount) async {
    try {
      log("CREATE & SEND OTP - $amount");
      final otpDao = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      otpChannel = otpDao[0].otpChannel;
      String url = "http://110.239.68.248:7070/api/otp/send-mailer";
      final spv = await GetIt.instance<AppDatabase>().authStoreDao.readEmailByTousrId();
      log("spv - $spv");
      if (spv == null) throw "Approver not found";
      if (spv.isEmpty) throw "Approver not found";

      final options = Options(headers: {"Content-Type": "application/json"});
      final formatter = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
      final formattedExpired = formatter.format(DateTime.now().toUtc().add(const Duration(hours: 1)));
      final formattedDateTime = formatter.format(DateTime.now().toUtc());

      final topos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      final store = await GetIt.instance<AppDatabase>().storeMasterDao.readByDocId(topos[0].tostrId!, null);
      final cashierMachine = await GetIt.instance<AppDatabase>().cashRegisterDao.readByDocId(topos[0].tocsrId!, null);
      final shift = await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.readLastValue();
      final cashierName = await GetIt.instance<AppDatabase>().userDao.readByDocId(shift!.tousrId!, null);

      Map<String, dynamic> dataToSend = {};
      if (amount != null) {
        final discount = Helpers.parseMoney(amount);
        dataToSend = {
          "uuid": "c3ba4678-bacf-4f60-9d2d-405f7bf8deed", // uuid master channel
          "channelId": otpChannel, // uuid smtp
          "Destination": spv[0]['email'],
          "Expired": formattedExpired,
          "RequestTimestamp": formattedDateTime,
          "isUsed": false,
          "additionalInfo": {
            "StoreName": store!.storeName,
            "CashierId": (cashierMachine!.description == "") ? cashierMachine.idKassa : cashierMachine.description,
            "CashierName": cashierName!.username,
            "DiscountAmmount": discount,
          }
        };
      } else {
        dataToSend = {
          "uuid": "c3ba4678-bacf-4f60-9d2d-405f7bf8deed", // uuid master channel
          "channelId": otpChannel, // uuid smtp
          "Destination": spv[0]['email'],
          "Expired": formattedExpired,
          "RequestTimestamp": formattedDateTime,
          "isUsed": false,
          "additionalInfo": {
            "StoreName": store!.storeName,
            "CashierId": (cashierMachine!.description == "") ? cashierMachine.idKassa : cashierMachine.description,
            "CashierName": cashierName!.username
          }
        };
      }
      log("Data2Send: ${jsonEncode(dataToSend)}");

      Response response = await _dio.post(
        url,
        data: dataToSend,
        options: options,
      );
      // log("response otp $response");
      // log("OTP SENT");
      return response.data;
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<String> validateOTP(String otp, String requester) async {
    try {
      // log("VALIDATE OTP");
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
