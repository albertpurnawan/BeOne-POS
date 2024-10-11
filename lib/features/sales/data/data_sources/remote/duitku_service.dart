import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/customer_cst.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:uuid/uuid.dart';

class DuitkuApi {
  final Dio _dio;

  DuitkuApi(this._dio) {
    _dio.options.followRedirects = false;
    _dio.options.validateStatus = (status) {
      return status != null && (status < 300 || status == 308);
    };
  }

  Future<Map<String, dynamic>> getApiKey() async {
    List<POSParameterModel> pos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
    final storeId = pos[0].tostrId ?? "";
    final store = await GetIt.instance<AppDatabase>().storeMasterDao.readByDocId(storeId, null);

    if (store != null) {
      return {
        "url": store.duitkuUrl,
        "merchantCode": store.duitkuMerchantCode,
        "apiKey": store.duitkuApiKey,
        "expiryPeriod": store.duitkuExpiryPeriod,
      };
    }
    return {};
  }

  Future<String> createTransactionSignature(int amount, String merchantOrderId) async {
    final params = await getApiKey();
    if (params.isEmpty) {
      throw Exception("Duitku parameters must be available.");
    }
    final combined = params['merchantCode'] + merchantOrderId + amount.toString() + params['apiKey'];
    final signature = md5.convert(utf8.encode(combined)).toString();
    return signature;
  }

  Future<String> createPaymentMethodsSignature(int amount, String timestamp) async {
    final params = await getApiKey();
    if (params.isEmpty) {
      throw Exception("Duitku parameters must be available.");
    }

    final combined = params['merchantCode'] + amount.toString() + timestamp + params['apiKey'];
    final signature = sha256.convert(utf8.encode(combined)).toString();
    return signature;
  }

  Future<String> createCheckStatusSignature(String merchantOrderId) async {
    final params = await getApiKey();
    if (params.isEmpty) {
      throw Exception("Duitku parameters must be available.");
    }

    final combined = params['merchantCode'] + merchantOrderId + params['apiKey'];
    final signature = md5.convert(utf8.encode(combined)).toString();
    return signature;
  }

  // Future<List<dynamic>> getPaymentMethods(String signature, int amount, String timestamp) async {
  //   final params = await getApiKey();
  //   if (params.isEmpty) {
  //     throw Exception("Duitku parameters must be available.");
  //   }
  //   String url = params["url"];

  //   final body = {
  //     "merchantcode": params["merchantCode"],
  //     "amount": amount,
  //     "datetime": timestamp,
  //     "signature": signature,
  //   };
  //   log("url - $url");
  //   log("body - ${json.encode(body)}");

  //   final response = await _dio.post(
  //     url,
  //     data: body,
  //   );

  //   log("Response methods duitku - ${response.data}");
  //   return response.data['paymentFee'];
  // }

  Future<dynamic> createTransactionVA(
      String paymentMethod, String signature, int amount, String custId, String merchantOrderId) async {
    final params = await getApiKey();
    if (params.isEmpty) {
      throw Exception("Duitku parameters must be available.");
    }

    String url = "${params['url']}/createTransactionRequest";

    final CustomerCstEntity? customerEntity =
        await GetIt.instance<AppDatabase>().customerCstDao.readByDocId(custId, null);
    final POSParameterEntity? topos = await GetIt.instance<GetPosParameterUseCase>().call();
    final docnum = const Uuid().v4();

    if (customerEntity == null) return;

    final body = {
      "docnum": docnum,
      "merchantCode": params["merchantCode"],
      "paymentAmount": amount,
      "paymentMethod": paymentMethod,
      "merchantOrderId": merchantOrderId,
      "productDetails": "Pembayaran untuk Toko ${topos!.storeName ?? "Contoh"}",
      "additionalParam": "",
      "merchantUserInfo": "",
      "customerVaName": customerEntity.custName,
      "email": customerEntity.email,
      "phoneNumber": customerEntity.phone,
      "callbackUrl": "${params['url']}/callback",
      "returnUrl": "https://mbahdukun1.github.io/duitku-website/",
      "signature": signature,
      "expiryPeriod": params["expiryPeriod"]
    };
    log("body duitku - ${jsonEncode(body)}");

    final response = await _dio.post(
      url,
      data: body,
    );

    log("Response duitku - ${response.data}");
    return response.data;
  }

  // Future<dynamic> checkVAPaymentStatus(String merchantOrderId) async {
  //   try {
  //     log("CHECKING PAYEMENT STATUS");
  //     final params = await getApiKey();
  //     if (params.isEmpty) {
  //       throw Exception("Duitku parameters must be available.");
  //     }
  //     String url = "${params['url']}/getCallbackOne/$merchantOrderId";

  //     log("url - $url");

  //     final response = await _dio.get(
  //       url,
  //     );

  //     log("response - ${response.data}");
  //     return response.data;
  //   } catch (e) {
  //     handleError(e);
  //     rethrow;
  //   }
  // }

  Future<dynamic> checkVAPaymentStatus(String signature, String merchantOrderId) async {
    try {
      final params = await getApiKey();
      if (params.isEmpty) {
        throw Exception("Duitku parameters must be available.");
      }
      const String url = "https://sandbox.duitku.com/webapi/api/merchant/transactionStatus";
      final body = {
        "merchantCode": params['merchantCode'],
        "merchantOrderId": merchantOrderId,
        "signature": signature,
      };
      log("body - $body");

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
