import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceApi {
  final Dio _dio;
  String? url;
  String? token;

  InvoiceApi(this._dio);

  Future<void> sendInvoice() async {
    try {
      log("SEND INVOICE SERVICE");
      SharedPreferences prefs = GetIt.instance<SharedPreferences>();
      token = prefs.getString('adminToken');

      List<POSParameterModel> pos =
          await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      url = pos[0].baseUrl;

      final invHead =
          await GetIt.instance<AppDatabase>().invoiceHeaderDao.readByLastDate();
      log(invHead.toString());

      final invDet = await GetIt.instance<AppDatabase>()
          .invoiceDetailDao
          .readByToinvId(invHead[0].docId.toString(), null);
      log(invDet.toString());

      final payMean = await GetIt.instance<AppDatabase>()
          .payMeansDao
          .readByToinvId(invHead[0].docId.toString(), null);
      log(payMean.toString());

      // if (invDet[0].toinvId == invHead[0].docId) {}

      final dataToSend = {
        "tostr_id": invHead[0].tostrId,
        "docnum": invHead[0].docnum,
        "orderno": invHead[0].orderNo,
        "tocus_id": invHead[0].tocusId,
        "tohem_id": invHead[0].tohemId,
        "transdate": invHead[0].transDateTime!.toUtc().toIso8601String(),
        "transtime": invHead[0].transDateTime!.toUtc().toIso8601String(),
        "timezone": invHead[0].timezone,
        "remarks": invHead[0].remarks ?? "",
        "subtotal": invHead[0].subTotal.toInt(),
        "discprctg": invHead[0].discPrctg,
        "discamount": invHead[0].discAmount,
        "discountcard": invHead[0].discountCard,
        "coupon": invHead[0].coupon,
        "discountcoupon": invHead[0].discountCoupun,
        "taxprctg": invHead[0].taxPrctg,
        // "taxamount": double.parse(invHead[0].taxAmount.toStringAsFixed(2)),
        "taxamount": 0,
        "addcost": invHead[0].addCost,
        "rounding": invHead[0].rounding,
        "grandtotal": invHead[0].grandTotal.toInt(),
        "changed": invHead[0].changed,
        "totalpayment": invHead[0].totalPayment.toInt(),
        "tocsr_id": invHead[0].tocsrId,
        "toinv_tohem_id": invHead[0].toinvTohemId,
        "invoice_item": invDet.map((item) {
          return {
            "docnum": item.docNum,
            "idnumber": item.idNumber,
            "toitm_id": item.toitmId,
            "quantity": item.quantity,
            "sellingprice": item.sellingPrice.toInt(),
            "discprctg": item.discPrctg,
            "discamount": item.discAmount,
            "totalamount": item.totalAmount.toInt(),
            "taxprctg": item.taxPrctg,
            "promotiontype": item.promotionType,
            "promotionid": item.promotionId,
            "remarks": item.remarks ?? "",
            "edittime": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                .format(item.editTime),
            "cogs": item.cogs,
            "tovat_id": item.tovatId,
            "promotiontingkat": item.promotionTingkat ?? "",
            "promovoucherno": item.promoVoucherNo ?? "",
            "includetax": item.includeTax,
            "toven_id": item.tovenId,
            "tbitm_id": item.tbitmId,
            "qtybarcode": 0.0,
            "sellpricebarcode": 0.0,
            "totalsellbarcode": 0.0,
            "disc1pct": 0.0,
            "disc1amt": 0.0,
            "disc2pct": 0.0,
            "disc2amt": 0.0,
            "disc3pct": 0.0,
            "disc3amt": 0.0,
            "disc1pctbarcode": 0.0,
            "disc1amtbarcode": 0.0,
            "disc2pctbarcode": 0.0,
            "disc2amtbarcode": 0.0,
            "disc3pctbarcode": 0.0,
            "disc3amtbarcode": 0.0,
            "totaldiscbarcode": 0.0,
            "qtyconv": 0.0,
            "discprctgmember": 0.0,
            "discamountmember": 0.0
          };
        }).toList(),
        "invoice_payment": [
          {"tpmt3_id": payMean[0].tpmt3Id, "amount": payMean[0].amount}
        ]
      };

      log("Data2Send: $dataToSend");

      await _dio.post(
        "$url/tenant-invoice/",
        data: dataToSend,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log("Success Post");
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
