import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';

class InvoiceApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  InvoiceApi(this._dio);

  Future<void> sendInvoice() async {
    try {
      final invHead =
          await GetIt.instance<AppDatabase>().invoiceHeaderDao.readAll();
      log(invHead[0].toString());
      final invDet =
          await GetIt.instance<AppDatabase>().invoiceDetailDao.readAll();
      log(invDet[0].toString());
      final payMean = await GetIt.instance<AppDatabase>().payMeansDao.readAll();
      log(payMean[0].toString());

      // if (invDet[0].toinvId == invHead[0].docId) {}

      final dataToSend = {
        "tostr_id": "878694e6-fdf4-49a7-82e3-d0facb685741",
        "docnum": "007-2212140001/SMPTEST",
        "orderno": 1,
        "tocus_id": "c2ee5bb8-9850-4014-b7bf-fd5492a60d84",
        "tohem_id": "a483a6f2-80e3-4093-bbc8-f03e79093098",
        "transdate": invHead[0].transDate,
        "transtime": invHead[0].transTime,
        "timezone": invHead[0].timezone,
        "remarks": invHead[0].remarks,
        "subtotal": invHead[0].subTotal,
        "discprctg": invHead[0].discPrctg,
        "discamount": invHead[0].discAmount,
        "discountcard": invHead[0].discountCard,
        "coupon": invHead[0].coupon,
        "discountcoupon": invHead[0].discountCoupun,
        "taxprctg": invHead[0].taxPrctg,
        "taxamount": invHead[0].taxAmount,
        "addcost": invHead[0].addCost,
        "rounding": invHead[0].rounding,
        "grandtotal": invHead[0].grandTotal,
        "changed": invHead[0].changed,
        "totalpayment": invHead[0].totalPayment,
        "tocsr_id": invHead[0].tocsrId,
        "toinv_tohem_id": "a483a6f2-80e3-4093-bbc8-f03e79093098",
        "invoice_item": [
          {
            "docnum": "007-2212140001/SMPTEST",
            "idnumber": invDet[0].idNumber,
            "toitm_id": "c08ecb51-5524-4683-bea5-15353a296d18",
            "quantity": invDet[0].quantity,
            "sellingprice": invDet[0].sellingPrice,
            "discprctg": invDet[0].discPrctg,
            "discamount": invDet[0].discAmount,
            "totalamount": invDet[0].totalAmount,
            "taxprctg": invDet[0].taxPrctg,
            "promotiontype": invDet[0].promotionType,
            "promotionid": invDet[0].promotionId,
            "remarks": invDet[0].remarks,
            "edittime": invDet[0].editTime,
            "cogs": invDet[0].cogs,
            "tovat_id": "4fdf5787-986b-46da-8e36-529edc076cb6",
            "promotiontingkat": invDet[0].promotionTingkat,
            "promovoucherno": invDet[0].promoVoucherNo,
            "includetax": invDet[0].includeTax,
            "toven_id": "3fe37695-f766-4550-9e1d-06697f337c9f",
            "tbitm_id": invDet[0].tbitmId,
            "discprctgmember": 0.0,
            "discamountmember": 0.0
          }
        ],
        "invoice_payment": [
          {"tpmt3_id": payMean[0].tpmt3Id, "amount": payMean[0].amount}
        ]
      };
      log(dataToSend.toString());

      // final response = await _dio.post(
      //   "$url/tenant-invoice/",
      //   data: dataToSend,
      //   options: Options(
      //     headers: {
      //       'Authorization': 'Bearer $token',
      //     },
      //   ),
      // );
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
