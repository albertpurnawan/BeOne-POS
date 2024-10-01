import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/domain/entities/customer_cst.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:uuid/uuid.dart';

class DuitkuApi {
  final Dio _dio;
  final String _url = "https://sandbox.duitku.com/webapi/api/merchant";
  final String _merchantCode = "DS20286";
  final String _apiKey = "338fdbf1c8ab5ee1c2f12d9d308fc888";

  DuitkuApi(this._dio) {
    _dio.options.followRedirects = false;
    _dio.options.validateStatus = (status) {
      return status != null && (status < 300 || status == 308);
    };
  }

  Future<String> createTransactionSignature(int amount, String merchantOrderId) async {
    final combined = _merchantCode + merchantOrderId + amount.toString() + _apiKey;
    final signature = md5.convert(utf8.encode(combined)).toString();
    return signature;
  }

  Future<String> createPaymentMethodsSignature(int amount, String timestamp) async {
    final combined = _merchantCode + amount.toString() + timestamp + _apiKey;
    final signature = sha256.convert(utf8.encode(combined)).toString();
    return signature;
  }

  Future<String> createCheckStatusSignature(String merchantOrderId) async {
    final combined = _merchantCode + merchantOrderId + _apiKey;
    final signature = md5.convert(utf8.encode(combined)).toString();
    return signature;
  }

  Future<List<dynamic>> getPaymentMethods(String signature, int amount, String timestamp) async {
    final String url = "$_url/paymentmethod/getpaymentmethod";
    final body = {
      "merchantcode": _merchantCode,
      "amount": amount,
      "datetime": timestamp,
      "signature": signature,
    };
    log("url - $url");
    log("body - ${json.encode(body)}");

    final response = await _dio.post(
      url,
      data: body,
    );

    log("Response methods duitku - ${response.data}");
    return response.data['paymentFee'];
  }

  Future<dynamic> createTransactionVA(
      String paymentMethod, String signature, int amount, String custId, String merchantOrderId) async {
    final String url = "$_url/v2/inquiry";
    final CustomerCstEntity? customerEntity =
        await GetIt.instance<AppDatabase>().customerCstDao.readByDocId(custId, null);
    final POSParameterEntity? topos = await GetIt.instance<GetPosParameterUseCase>().call();
    final docnum = Uuid().v4();

    if (customerEntity == null) return;

    final body = {
      "docnum": docnum,
      "merchantCode": _merchantCode,
      "paymentAmount": amount,
      "paymentMethod": paymentMethod,
      "merchantOrderId": merchantOrderId,
      "productDetails": "Pembayaran untuk Toko ${topos!.storeName ?? "Contoh"}",
      "additionalParam": "",
      "merchantUserInfo": "",
      "customerVaName": customerEntity.custName,
      "email": customerEntity.email,
      "phoneNumber": customerEntity.phone,
      // "customerDetail": {
      //   "firstName": "John",
      //   "lastName": "Doe",
      //   "email": "pelanggan_anda@email.com",
      //   "phoneNumber": "085718159655",
      //   "billingAddress": {
      //     "firstName": "John",
      //     "lastName": "Doe",
      //     "address": "Jl. Kembangan Raya",
      //     "city": "Jakarta",
      //     "postalCode": "11530",
      //     "phone": "085718159655",
      //     "countryCode": "ID"
      //   },
      //   "shippingAddress": {
      //     "firstName": "John",
      //     "lastName": "Doe",
      //     "address": "Jl. Kembangan Raya",
      //     "city": "Jakarta",
      //     "postalCode": "11530",
      //     "phone": "085718159655",
      //     "countryCode": "ID"
      //   }
      // },
      "callbackUrl": "http://110.239.68.248:7065/callback",
      "returnUrl": "",
      "signature": signature,
      "expiryPeriod": 129600
    };
    log("body duitku - ${jsonEncode(body)}");

    final response = await _dio.post(
      url,
      data: body,
    );

    log("Response duitku - ${response.data}");
    return response.data;
  }

  Future<dynamic> checkVAPaymentStatus(String signature, String merchantOrderId) async {
    try {
      final String url = "$_url/transactionStatus";
      final body = {
        "merchantCode": _merchantCode,
        "merchantOrderId": merchantOrderId,
        "signature": signature,
      };

      final response = await _dio.post(
        url,
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      log("response - ${response.data}");
      return response.data;
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }
}
