import 'dart:developer' as dev;
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/domain/entities/netzme_entity.dart';

class NetzmeApi {
  final Dio _dio;
  String externalId = '';
  String channelId = '95221';
  String timestamp = '';
  String signature = '';
  String accessToken = '';
  String partnerReferenceNo = '';

  NetzmeApi(this._dio) {
    _dio.options.followRedirects = false;
    _dio.options.validateStatus = (status) {
      return status != null && (status < 300 || status == 308);
    };
  }
  String getTimestamp() {
    DateTime now = DateTime.now();
    String formattedDateTime = now.toIso8601String().split('.').first;
    String timezoneOffset = now.timeZoneOffset.isNegative ? "-" : "+";
    int hours = now.timeZoneOffset.inHours.abs();
    int minutes = now.timeZoneOffset.inMinutes.abs() % 60;

    String formattedOffset =
        "$timezoneOffset${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
    timestamp = formattedDateTime + formattedOffset;
    return timestamp;
  }

  String generateRandomString(int length) {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }

  Future<String> createSignature(
    String url,
    String clientKey,
    String privateKey,
  ) async {
    try {
      timestamp = getTimestamp();
      dev.log("Timestamp - $timestamp");

      final header = {
        "X-TIMESTAMP": timestamp,
        "X-CLIENT-KEY": clientKey,
        "Private_Key": privateKey,
      };

      final response = await _dio.post(
        "$url/api/v1/utilities/signature-auth",
        options: Options(headers: header),
      );

      signature = response.data['signature'];

      dev.log("Signature Created");
      return signature;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<String> requestAccessToken(
    String url,
    String clientKey,
    String privateKey,
    String xsignature,
  ) async {
    try {
      final header = {
        "X-TIMESTAMP": timestamp,
        "X-CLIENT-KEY": clientKey,
        "X-SIGNATURE": xsignature,
      };

      final body = {
        "grantType": "client_credentials",
        "additionalInfo": {},
      };

      final response = await _dio.post(
        "$url/api/v1/access-token/b2b",
        data: body,
        options: Options(headers: header),
      );

      accessToken = response.data['accessToken'];
      dev.log("AccessToken Done");
      return accessToken;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<String> createSignatureService(
    String url,
    String clientKey,
    String clientSecret,
    String privateKey,
    String xaccessToken,
    String serviceUrl,
    Map<String, dynamic> bodyDetail,
  ) async {
    try {
      String serviceSignature = "";

      final header = {
        "X-TIMESTAMP": timestamp,
        "X-CLIENT-SECRET": clientSecret,
        "AccessToken": "Bearer $xaccessToken",
        "Content-Type": "application/json",
        "HttpMethod": "POST",
        "EndpointUrl": "/$serviceUrl",
      };

      final response = await _dio.post(
        "$url/api/v1/utilities/signature-service",
        data: bodyDetail,
        options: Options(headers: header),
      );

      serviceSignature = response.data['signature'];

      dev.log("ServiceSignature Done");
      return serviceSignature;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<NetzMeEntity> createTransactionQRIS(
    String url,
    String clientKey,
    String clientSecret,
    String privateKey,
    String xsignature,
    Map<String, dynamic> bodyDetail,
  ) async {
    try {
      String qrImage = '';

      externalId = (Random().nextDouble() * pow(10, 21)).floor().toString();
      final header = {
        "X-TIMESTAMP": timestamp,
        "X-CLIENT-SECRET": clientSecret,
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
        "X-PARTNER-ID": clientKey,
        "X-EXTERNAL-ID": externalId,
        "CHANNEL-ID": channelId,
        // "x-callback-token": "UIEFnYhIPHP43s5tRYJPR4ZU/gPBdwtS5n5ONN8F/3g=",
        "X-SIGNATURE": xsignature,
      };

      final response = await _dio.post(
        "$url/api/v1.0/invoice/create-transaction",
        data: bodyDetail,
        options: Options(headers: header),
      );

      qrImage = response.data['additionalInfo']['qrImage'];
      RegExp regex = RegExp(r'data:image/png;base64,(.*)$');
      Match match = regex.firstMatch(qrImage) as Match;
      String imageString = match.group(1)!;

      final NetzMeEntity responseDetails = NetzMeEntity(
        responseMessage: response.data['responseMessage'],
        paymentUrl: response.data['paymentUrl'],
        qrImage: imageString,
        trxId: response.data['additionalInfo']['trxId'],
        terminalId: response.data['additionalInfo']['terminalId'],
        nmid: response.data['additionalInfo']['nmid'],
        feeAmount: response.data['additionalInfo']['feeAmount'],
        totalAmount: response.data['additionalInfo']['totalAmount'],
        createdTs: response.data['additionalInfo']['createdTs'],
        expiredTs: response.data['additionalInfo']['expiredTs'],
      );

      dev.log("CreateTransaction Done");
      return responseDetails;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<String> checkPaymentStatus(
    String url,
    String clientKey,
    String privateKey,
    String xsignature,
    Map<String, dynamic> bodyDetail,
  ) async {
    try {
      externalId = (Random().nextDouble() * pow(10, 21)).floor().toString();
      final header = {
        "Content-Type": "application/json",
        "CHANNEL-ID": channelId,
        "X-EXTERNAL-ID": externalId,
        "X-PARTNER-ID": clientKey,
        "X-SIGNATURE": xsignature,
        "X-TIMESTAMP": timestamp,
        "Authorization": "Bearer $accessToken",
      };

      final response = await _dio.post(
        "$url/api-invoice/v1.0/transaction-history-detail",
        data: bodyDetail,
        options: Options(headers: header),
      );

      dev.log("CheckQRISStatus Done");
      return response.data['additionalInfo']['invoiceStatus'];
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }
}
