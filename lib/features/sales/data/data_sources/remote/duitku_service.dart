import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:pos_fe/core/utilities/helpers.dart';

class DuitkuApi {
  final Dio _dio;
  final String _url = "https://sandbox.duitku.com/webapi/api/merchant";
  final String _merchantOrderId = Helpers.generateRandomString(10);
  final String _merchantCode = "DS20286";
  final String _apiKey = "338fdbf1c8ab5ee1c2f12d9d308fc888";
  final String timestamp = Helpers.getTimestamp();

  DuitkuApi(this._dio) {
    _dio.options.followRedirects = false;
    _dio.options.validateStatus = (status) {
      return status != null && (status < 300 || status == 308);
    };
  }

  Future<String> createTransactionSignature(int amount) async {
    final combined = _merchantCode + _merchantOrderId + amount.toString() + _apiKey;
    final signature = md5.convert(utf8.encode(combined)).toString();
    log("combined duitku - $combined");
    log("signature duitku - $signature");
    return signature;
  }

  Future<String> createPaymentMethodsSignature(int amount) async {
    log("timestamp - $timestamp");
    final combined = _merchantCode + amount.toString() + timestamp + _apiKey;
    final signature = sha256.convert(utf8.encode(combined)).toString();
    return signature;
  }

  Future<List<dynamic>> getPaymentMethods(String signature, int amount) async {
    final String url = "$_url/paymentmethod/getpaymentmethod";
    log("timestamp get - $timestamp");
    final body = {
      "merchantcode": _merchantCode,
      "amount": amount,
      "datetime": timestamp,
      "signature": signature,
    };

    log("body - ${json.encode(body)}");

    final response = await _dio.post(
      url,
      data: body,
    );

    log("Response duitku - ${response.data['paymentFee']}");
    return response.data['paymentFee'];
  }

  Future<String> createTransactionVA(String signature, int amount) async {
    final String url = "$_url/v2/inquiry";
    final body = {
      "merchantCode": _merchantCode,
      "paymentAmount": amount,
      "paymentMethod": "BC",
      "merchantOrderId": _merchantOrderId,
      "productDetails": "Pembayaran untuk Toko Contoh",
      "additionalParam": "",
      "merchantUserInfo": "",
      "customerVaName": "John Doe",
      "email": "pelanggan_anda@email.com",
      "phoneNumber": "08123456789",
      "customerDetail": {
        "firstName": "John",
        "lastName": "Doe",
        "email": "pelanggan_anda@email.com",
        "phoneNumber": "085718159655",
        "billingAddress": {
          "firstName": "John",
          "lastName": "Doe",
          "address": "Jl. Kembangan Raya",
          "city": "Jakarta",
          "postalCode": "11530",
          "phone": "085718159655",
          "countryCode": "ID"
        },
        "shippingAddress": {
          "firstName": "John",
          "lastName": "Doe",
          "address": "Jl. Kembangan Raya",
          "city": "Jakarta",
          "postalCode": "11530",
          "phone": "085718159655",
          "countryCode": "ID"
        }
      },
      "callbackUrl": "",
      "returnUrl": "",
      "signature": signature,
      "expiryPeriod": 60
    };
    log("body duitku - ${jsonEncode(body)}");
    final response = await _dio.post(
      url,
      data: body,
    );

    log("Response duitku - $response");
    return response.statusMessage ?? "Failed";
  }
}
