import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/invoice_detail_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/invoice_header_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/pay_means_service.dart';

class InvoiceApi {
  final Dio _dio;
  String token = Constant.token;
  String url = Constant.url;

  InvoiceApi(this._dio);

  Future<void> sendInvoice() async {
    try {
      final invHead = await GetIt.instance<InvoiceHeaderApi>().fetchData();
      log(invHead.toString());
      final invDet = await GetIt.instance<InvoiceDetailApi>().fetchData();
      final payMean = await GetIt.instance<PayMeansApi>().fetchData();

      final dataToSend = {
        "tostr_id",
        "docnum",
        "orderno",
        "tocus_id",
        "tohem_id",
        "transdate",
        "transtime",
        "timezone",
        "remarks",
        "subtotal",
        "discprctg",
        "discamount",
        "discountcard",
        "coupon",
        "discountcoupon",
        "taxprctg",
        "taxamount",
        "addcost",
        "rounding",
        "grandtotal",
        "changed",
        "totalpayment",
        "tocsr_id",
        "docstatus",
        "sync",
        "toinv_tohem_id",
        "invoice_item",
        "invoice_item.*.linenum",
        "invoice_item.*.docnum",
        "invoice_item.*.idnumber",
        "invoice_item.*.toitm_id",
        "invoice_item.*.quantity",
        "invoice_item.*.sellingprice",
        "invoice_item.*.discprctg",
        "invoice_item.*.discamount",
        "invoice_item.*.totalamount",
        "invoice_item.*.taxprctg",
        "invoice_item.*.promotiontype",
        "invoice_item.*.promotionid",
        "invoice_item.*.remarks",
        "invoice_item.*.edittime",
        "invoice_item.*.cogs",
        "invoice_item.*.tovat_id",
        "invoice_item.*.promotiontingkat",
        "invoice_item.*.promovoucherno",
        "invoice_item.*.basedocid",
        "invoice_item.*.baselinedocid",
        "invoice_item.*.includetax",
        "invoice_item.*.toven_id",
        "invoice_item.*.tbitm_id",
        "invoice_item.*.qtybarcode",
        "invoice_item.*.sellpricebarcode",
        "invoice_item.*.totalsellbarcode",
        "invoice_item.*.disc1pct",
        "invoice_item.*.disc1amt",
        "invoice_item.*.disc2pct",
        "invoice_item.*.disc2amt",
        "invoice_item.*.disc3pct",
        "invoice_item.*.disc3amt",
        "invoice_item.*.disc1pctbarcode",
        "invoice_item.*.disc1amtbarcode",
        "invoice_item.*.disc2pctbarcode",
        "invoice_item.*.disc2amtbarcode",
        "invoice_item.*.disc3pctbarcode",
        "invoice_item.*.disc3amtbarcode",
        "invoice_item.*.totaldiscbarcode",
        "invoice_item.*.qtyconv",
        "invoice_item.*.discprctgmember",
        "invoice_item.*.discamountmember",
        "invoice_payment",
        "invoice_payment.*.linenum",
        "invoice_payment.*.tpmt3_id",
        "invoice_payment.*.amount",
        "invoice_payment.*.tpmt2_id",
        "invoice_payment.*.cardno",
        "invoice_payment.*.cardholder",
        "invoice_payment.*.sisavoucher",
        "invoice_payment.*.type",
        "invoice_payment.*.invoice_voucher",
      };

      await _dio.post(
        "http://192.168.1.34:3001/tenant-invoice/",
        data: dataToSend,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}
