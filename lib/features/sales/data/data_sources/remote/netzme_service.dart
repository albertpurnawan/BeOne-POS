import 'dart:developer' as dev;
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';

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

    String formattedOffset = timezoneOffset +
        hours.toString().padLeft(2, '0') +
        ":" +
        minutes.toString().padLeft(2, '0');
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

      if (response.statusCode == 308) {
        final newUrl = response.headers['location']?.first;
        if (newUrl != null) {
          final redirectedResponse = await _dio.post(newUrl,
              options: Options(
                headers: header,
              ));
          signature = redirectedResponse.data['signature'];
        } else {
          throw Exception("Redirect URL not found in the response headers");
        }
      }
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

      if (response.statusCode == 308) {
        final newUrl = response.headers['location']?.first;

        if (newUrl != null) {
          final redirectedResponse = await _dio.post(newUrl,
              data: body,
              options: Options(
                headers: header,
                validateStatus: (_) => true,
              ));
          accessToken = redirectedResponse.data['accessToken'];
        } else {
          throw Exception("Redirect URL not found in the response headers");
        }
      }
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
    Map<String, dynamic> bodyDetail,
  ) async {
    try {
      String serviceSignature = "";
      String serviceUrl = "api/v1.0/invoice/create-transaction";

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

      if (response.statusCode == 308) {
        final newUrl = response.headers['location']?.first;

        if (newUrl != null) {
          final redirectedResponse = await _dio.post(newUrl,
              data: bodyDetail,
              options: Options(
                headers: header,
                validateStatus: (_) => true,
              ));
          serviceSignature = redirectedResponse.data['signature'];
        } else {
          throw Exception("Redirect URL not found in the response headers");
        }
      }
      dev.log("ServiceSignature Done");
      return serviceSignature;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<String> createTransactionQRIS(
    String url,
    String clientKey,
    String clientSecret,
    String privateKey,
    String xsignature,
    Map<String, dynamic> bodyDetail,
  ) async {
    try {
      String transactionQRIS = '';
      externalId = (Random().nextDouble() * pow(10, 21)).floor().toString();
      final header = {
        "X-TIMESTAMP": timestamp,
        "X-CLIENT-SECRET": clientSecret,
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
        "X-PARTNER-ID": clientKey,
        "X-EXTERNAL-ID": externalId,
        "CHANNEL-ID": channelId,
        "X-SIGNATURE": xsignature,
      };

      final response = await _dio.post(
        "$url/api/v1.0/invoice/create-transaction",
        data: bodyDetail,
        options: Options(headers: header),
      );

      if (response.statusCode == 308) {
        final newUrl = response.headers['location']?.first;

        if (newUrl != null) {
          final redirectedResponse = await _dio.post(newUrl,
              data: bodyDetail,
              options: Options(
                headers: header,
                validateStatus: (_) => true,
              ));
          dev.log("$redirectedResponse");
          transactionQRIS = redirectedResponse.data['paymentUrl'];
        } else {
          throw Exception("Redirect URL not found in the response headers");
        }
      }
      dev.log("CreateTransaction Done");

      return transactionQRIS;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
