import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/invoice_detail.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_down_payment.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceApi {
  final Dio _dio;
  String? url;
  String? token;
  final SharedPreferences prefs;

  InvoiceApi(this._dio, this.prefs);

  Future<void> sendInvoice(List<String> docnums) async {
    try {
      log("SEND INVOICE SERVICE");
      token = prefs.getString('adminToken');

      List<POSParameterModel> pos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      url = pos[0].baseUrl;

      final invHead = await GetIt.instance<AppDatabase>().invoiceHeaderDao.readByLastDate();
      log("invHead - $invHead");

      final invDet =
          await GetIt.instance<AppDatabase>().invoiceDetailDao.readByToinvIdAddQtyBarcode(invHead[0].docId.toString());
      log("invDet - $invDet");

      final payMean = await GetIt.instance<AppDatabase>().payMeansDao.readByToinvShowTopmt(invHead[0].docId.toString());
      log("paymean - $payMean");

      List<Map<String, dynamic>> invoicePayments = [];
      if (payMean != null) {
        for (var entry in payMean) {
          switch (entry['paytypecode']) {
            case "1": // TUNAI
              // if (entry['amount'] < 0) break;
              if (entry['amount'] == 0 && invHead[0].grandTotal != 0) {
                invoicePayments.add({
                  "tpmt3_id": entry['tpmt3Id'],
                  "amount": entry['amount'],
                  "rrn": entry['rrn'] ?? "",
                });
              } else {
                invoicePayments.add({
                  "tpmt3_id": entry['tpmt3Id'],
                  "amount": entry['amount'],
                  "rrn": entry['rrn'] ?? "",
                });
              }
              break;
            case "2": // EDC
              if (entry['tpmt2Id'] == null) {
                invoicePayments.add({
                  "tpmt3_id": entry['tpmt3Id'],
                  "amount": entry['amount'],
                  "cardno": entry['cardno'],
                  "cardholder": entry['cardholder'],
                  "rrn": entry['rrn'] ?? "",
                });
              } else {
                invoicePayments.add({
                  "tpmt3_id": entry['tpmt3Id'],
                  "amount": entry['amount'],
                  "tpmt2_id": entry['tpmt2Id'],
                  "cardno": entry['cardno'],
                  "cardholder": entry['cardholder'],
                  "rrn": entry['rrn'] ?? "",
                  if (entry['tpmt2Id'] != null) "tpmt6_id": entry['tpmt6Id'],
                });
              }
              break;
            case "6": // VOUCHERS
              final vouchers =
                  await GetIt.instance<AppDatabase>().vouchersSelectionDao.readBytinv2Id(entry['docid'], txn: null);
              // log("vouchers - $vouchers");

              Map<String, Map<String, dynamic>> groupedPayments = {};

              if (vouchers.isNotEmpty) {
                for (var voucher in vouchers) {
                  String tpmt3Id = voucher.tpmt3Id!;
                  if (!groupedPayments.containsKey(tpmt3Id)) {
                    groupedPayments[tpmt3Id] = {
                      "tpmt3_id": tpmt3Id,
                      "amount": 0.0,
                      "sisavoucher": 0,
                      "invoice_voucher": [],
                      "rrn": entry['rrn'] ?? "",
                    };
                  }

                  groupedPayments[tpmt3Id]!['amount'] += voucher.voucherAmount;

                  bool typeExists = false;
                  for (var voucherEntry in groupedPayments[tpmt3Id]!['invoice_voucher']) {
                    if (voucherEntry['type'] == voucher.type) {
                      voucherEntry['serialno'].add(voucher.serialNo);
                      typeExists = true;
                      break;
                    }
                  }
                  if (!typeExists) {
                    groupedPayments[tpmt3Id]!['invoice_voucher'].add({
                      "serialno": [voucher.serialNo],
                      "type": voucher.type
                    });
                  }
                }

                List<Map<String, dynamic>> groupedPaymentsList = groupedPayments.values.toList();

                for (var groupedPayment in groupedPaymentsList) {
                  invoicePayments.add(groupedPayment);
                  // log("invoicePayment - $invoicePayments");
                }
              }
              double totalAmount = 0.0;
              for (var payment in invoicePayments) {
                totalAmount += payment['amount'];
              }
              if (totalAmount > invHead[0].grandTotal) {
                double excessAmount = totalAmount - invHead[0].grandTotal;
                invoicePayments[invoicePayments.length - 1]['sisavoucher'] = excessAmount;
              }

              break;
            default:
              invoicePayments.add({
                "tpmt3_id": entry['tpmt3Id'],
                "amount": entry['amount'],
                "rrn": entry['rrn'] ?? "",
              });
              break;
          }
        }
      }

      List<Map<String, dynamic>> promotionsHeader = [];
      if (invHead[0].discHeaderManual != 0 || invHead[0].discountCoupun > 0) {
        final promoHeader =
            await GetIt.instance<AppDatabase>().invoiceAppliedPromoDao.readByToinvId(invHead[0].docId!, null);
        List<Map<String, dynamic>> promoMaps =
            promoHeader.map((promo) => promo.promoToMapWithEmptyString(promo)).toList();
        promotionsHeader.addAll(promoMaps);
      }
      log("promotionsHeader - $promotionsHeader");

      List<Map<String, dynamic>> promotionsDetail = [];
      for (final tinv1 in invDet) {
        log("Processing item: $tinv1");

        final appliedPromos = await GetIt.instance<AppDatabase>()
            .invoiceAppliedPromoDao
            .readByToinvIdAndTinv1Id(tinv1['toinvId'], tinv1['docid'], null);

        List<Map<String, dynamic>> promoMaps = appliedPromos.map((promo) => promo.toMap()).toList();

        promotionsDetail.addAll(promoMaps);
      }
      log("promotionsDetail - $promotionsDetail");

      List<Map<String, dynamic>> approvals = [];
      final tinv6s = await GetIt.instance<AppDatabase>().approvalInvoiceDao.readByToinvId(invHead[0].docId!, null);
      // log("tinv6s - $tinv6s");
      for (final tinv6 in tinv6s) {
        Map<String, dynamic> tinv6Maps = {
          "tousr_id": tinv6!.tousrId,
          "remarks": tinv6.remarks,
          "category": tinv6.category,
        };
        approvals.add(tinv6Maps);
      }

      final tinv7s = await GetIt.instance<AppDatabase>().downPaymentItemsDao.readByToinvId(invHead[0].docId!, null);
      log("tinv7s - $tinv7s");
      final List<Map<String, dynamic>> downPaymentItems = [];

      for (final tinv7 in tinv7s) {
        downPaymentItems.add({
          "docnum": invHead[0].docnum,
          "idnumber": tinv7!.idNumber,
          "toitm_id": tinv7.toitmId,
          "quantity": tinv7.quantity,
          "sellingprice": tinv7.sellingPrice.round(),
          "discprctg": 0,
          "discamount": 0,
          "totalamount": tinv7.totalAmount,
          "taxprctg": 0,
          "promotiontype": "",
          "promotionid": "",
          "remarks": tinv7.remarks ?? "",
          "edittime": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
          "cogs": 0,
          "tovat_id": tinv7.tovatId,
          "promotiontingkat": "",
          "promovoucherno": "",
          "includetax": tinv7.includeTax,
          "toven_id": tinv7.tovenId,
          "tbitm_id": tinv7.tbitmId,
          "qtybarcode": tinv7.quantity,
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
          "qtyconv": tinv7.quantity,
          "discprctgmember": 0.0,
          "discamountmember": 0.0,
          "tohem_id": tinv7.tohemId,
          "refpos2": tinv7.refpos2 ?? "",
          "promotion": []
        });
      }

      final dataToSend = {
        "tostr_id": invHead[0].tostrId,
        "docnum": invHead[0].docnum,
        "orderno": invHead[0].orderNo,
        "tocus_id": invHead[0].tocusId,
        "tohem_id": invHead[0].tohemId,
        "transdate": invHead[0]
            .transDateTime!
            .add(Duration(hours: DateTime.now().timeZoneOffset.inHours))
            .toUtc()
            .toIso8601String(),
        "transtime": invHead[0]
            .transDateTime!
            .add(Duration(hours: DateTime.now().timeZoneOffset.inHours))
            .toUtc()
            .toIso8601String(),
        "timezone": invHead[0].timezone,
        "remarks": invHead[0].remarks ?? "",
        "subtotal": (invHead[0].subTotal - (invHead[0].discHeaderPromo ?? 0)).round(),
        "discprctg": invHead[0].subTotal == 0
            ? 0
            : 100 *
                ((invHead[0].discAmount - (invHead[0].discHeaderPromo ?? 0) + invHead[0].discountCoupun) /
                    (invHead[0].subTotal - (invHead[0].discHeaderPromo ?? 0))),
        "discamount": invHead[0].discAmount - (invHead[0].discHeaderPromo ?? 0) + invHead[0].discountCoupun,
        "discountcard": invHead[0].discountCard,
        "coupon": invHead[0].coupon,
        // "discountcoupon": invHead[0].discountCoupun,
        "discountcoupon": 0,
        "taxprctg": invHead[0].taxPrctg,
        "taxamount": double.parse(invHead[0].taxAmount.toStringAsFixed(2)),
        "addcost": invHead[0].addCost,
        "rounding": invHead[0].rounding,
        "grandtotal": invHead[0].grandTotal.round(),
        "changed": invHead[0].changed,
        "totalpayment": invHead[0].totalPayment.round() - invHead[0].changed,
        "tocsr_id": invHead[0].tocsrId,
        "toinv_tohem_id": invHead[0].toinvTohemId,
        "refpos1": invHead[0].refpos1,
        "invoice_item": invDet.map((item) {
          List<Map<String, dynamic>> filteredPromotions = promotionsDetail.where((promo) {
            return promo['tinv1docid'] == item['docid'];
          }).toList();
          return {
            "docnum": item['docnum'],
            "idnumber": item['idnumber'],
            "toitm_id": item['toitmId'],
            "quantity": item['quantity'],
            "sellingprice": item['sellingprice'].round(),
            "discprctg": item['discprctg'],
            "discamount": item['discamount'],
            "totalamount":
                ((item['quantity'] * item['sellingprice'] * (100 / (100 + item['taxprctg']))) - item['discamount'])
                    .round(),
            "taxprctg": item['taxprctg'],
            "promotiontype": item['promotiontype'],
            "promotionid": item['promotionid'],
            "remarks": item['remarks'] ?? "",
            "edittime": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(item['edittime'])),
            "cogs": item['cogs'],
            "tovat_id": item['tovatId'],
            "promotiontingkat": item['promotiontingkat'] ?? "",
            "promovoucherno": item['promovoucherno'] ?? "",
            "includetax": item['includetax'],
            "toven_id": item['tovenId'],
            "tbitm_id": item['tbitmId'],
            "qtybarcode": item['quantity'], // quantity barcode scanned x times
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
            "qtyconv": item['qtybarcode'] * item['quantity'], // qtybarcode * qtytbitm?
            "discprctgmember": 0.0,
            "discamountmember": 0.0,
            "tohem_id": (item['tohemId'] == "") ? invHead[0].salesTohemId : item['tohemId'],
            "refpos2": item['refpos2'],
            "refpos3": item['refpos3'],
            "promotion": filteredPromotions
          };
        }).toList(),
        "invoice_payment": invoicePayments,
        "promotion": promotionsHeader,
        "approval": approvals,
        "downpayment_docnums": docnums,
      };
      if (invHead[0].salesTohemId != "") {
        dataToSend["sales_tohem_id"] = invHead[0].salesTohemId;
      }
      if (tinv7s.isNotEmpty) {
        dataToSend["downpayment_item"] = downPaymentItems;
      }
      // if (invHead[0].refpos2 != null) {
      //   dataToSend["refpos2"] = invHead[0].refpos2;
      // }

      log("Data2Send: ${jsonEncode(dataToSend)}");

      Response response = await _dio.post(
        "$url/tenant-invoice/",
        data: dataToSend,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log("response - $response");

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        // log("Success Post");
        final invHeaderSuccess = InvoiceHeaderModel(
          docId: invHead[0].docId,
          createDate: invHead[0].createDate,
          updateDate: invHead[0].updateDate,
          tostrId: invHead[0].tostrId,
          docnum: invHead[0].docnum,
          orderNo: invHead[0].orderNo,
          tocusId: invHead[0].tocusId,
          tohemId: invHead[0].tohemId,
          transDateTime: invHead[0].transDateTime,
          timezone: invHead[0].timezone,
          remarks: invHead[0].remarks,
          subTotal: invHead[0].subTotal,
          discPrctg: invHead[0].discPrctg,
          discAmount: invHead[0].discAmount,
          discountCard: invHead[0].discountCard,
          coupon: invHead[0].coupon,
          discountCoupun: invHead[0].discountCoupun,
          taxPrctg: invHead[0].taxPrctg,
          taxAmount: invHead[0].taxAmount,
          addCost: invHead[0].addCost,
          rounding: invHead[0].rounding,
          grandTotal: invHead[0].grandTotal,
          changed: invHead[0].changed,
          totalPayment: invHead[0].totalPayment,
          tocsrId: invHead[0].tocsrId,
          docStatus: invHead[0].docStatus,
          sync: invHead[0].sync,
          syncCRM: invHead[0].syncCRM,
          toinvTohemId: invHead[0].toinvTohemId,
          refpos1: invHead[0].refpos1,
          refpos2: invHead[0].refpos2,
          tcsr1Id: invHead[0].tcsr1Id,
          discHeaderManual: invHead[0].discHeaderManual,
          discHeaderPromo: invHead[0].discHeaderPromo,
          syncToBos: response.data['docid'],
          paymentSuccess: invHead[0].paymentSuccess,
          salesTohemId: invHead[0].salesTohemId,
        );

        await GetIt.instance<AppDatabase>().invoiceHeaderDao.update(
              docId: invHead[0].docId!,
              data: invHeaderSuccess,
            );
      }
      // handle duplicate send invoice
    } catch (err) {
      if (err is DioException) {
        log("error response data ${err.response?.data}");
      }
      handleError(err);
      rethrow;
    }
  }

  Future<void> sendFailedInvoice(InvoiceHeaderModel invHead, List<InvoiceDetailModel> invDet) async {
    try {
      // log("SEND FAILED INVOICE SERVICE");
      token = prefs.getString('adminToken');
      List<POSParameterModel> pos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      url = pos[0].baseUrl;

      // log("$invHead");
      // log("$invDet");
      final invDetWithQtyBarcode =
          await GetIt.instance<AppDatabase>().invoiceDetailDao.readByToinvIdAddQtyBarcode(invHead.docId.toString());

      final payMean = await GetIt.instance<AppDatabase>().payMeansDao.readByToinvShowTopmt(invHead.docId.toString());
      log("paymean - $payMean");

      List<Map<String, dynamic>> invoicePayments = [];
      if (payMean != null) {
        for (var entry in payMean) {
          switch (entry['paytypecode']) {
            case "1": // TUNAI
              if (entry['amount'] < 0) break;
              if (entry['amount'] == 0 && invHead.grandTotal != 0) {
                invoicePayments.add({
                  "tpmt3_id": entry['tpmt3Id'],
                  "amount": entry['amount'],
                  "rrn": entry['rrn'] ?? "",
                });
              } else {
                invoicePayments.add({
                  "tpmt3_id": entry['tpmt3Id'],
                  "amount": entry['amount'],
                  "rrn": entry['rrn'] ?? "",
                });
              }
              break;
            case "2": // EDC
              if (entry['tpmt2Id'] == null) {
                invoicePayments.add({
                  "tpmt3_id": entry['tpmt3Id'],
                  "amount": entry['amount'],
                  "cardno": entry['cardno'],
                  "cardholder": entry['cardholder'],
                  "rrn": entry['rrn'] ?? "",
                  "tpmt6_id": "",
                });
              } else {
                invoicePayments.add({
                  "tpmt3_id": entry['tpmt3Id'],
                  "amount": entry['amount'],
                  "tpmt2_id": entry['tpmt2Id'],
                  "cardno": entry['cardno'],
                  "cardholder": entry['cardholder'],
                  "rrn": entry['rrn'] ?? "",
                  "tpmt6_id": "",
                });
              }
              break;
            case "6": // VOUCHERS
              final vouchers =
                  await GetIt.instance<AppDatabase>().vouchersSelectionDao.readBytinv2Id(entry['docid'], txn: null);
              // log("vouchers - $vouchers");

              Map<String, Map<String, dynamic>> groupedPayments = {};

              if (vouchers.isNotEmpty) {
                for (var voucher in vouchers) {
                  String tpmt3Id = voucher.tpmt3Id!;
                  if (!groupedPayments.containsKey(tpmt3Id)) {
                    groupedPayments[tpmt3Id] = {
                      "tpmt3_id": tpmt3Id,
                      "amount": 0.0,
                      "sisavoucher": 0,
                      "invoice_voucher": [],
                      "rrn": entry['rrn'] ?? "",
                    };
                  }

                  groupedPayments[tpmt3Id]!['amount'] += voucher.voucherAmount;

                  bool typeExists = false;
                  for (var voucherEntry in groupedPayments[tpmt3Id]!['invoice_voucher']) {
                    if (voucherEntry['type'] == voucher.type) {
                      voucherEntry['serialno'].add(voucher.serialNo);
                      typeExists = true;
                      break;
                    }
                  }
                  if (!typeExists) {
                    groupedPayments[tpmt3Id]!['invoice_voucher'].add({
                      "serialno": [voucher.serialNo],
                      "type": voucher.type
                    });
                  }
                }

                List<Map<String, dynamic>> groupedPaymentsList = groupedPayments.values.toList();

                for (var groupedPayment in groupedPaymentsList) {
                  invoicePayments.add(groupedPayment);
                  // log("invoicePayment - $invoicePayments");
                }
              }
              double totalAmount = 0.0;
              for (var payment in invoicePayments) {
                totalAmount += payment['amount'];
              }
              if (totalAmount > invHead.grandTotal) {
                double excessAmount = totalAmount - invHead.grandTotal;
                invoicePayments[invoicePayments.length - 1]['sisavoucher'] = excessAmount;
              }

              break;
            default:
              invoicePayments.add({
                "tpmt3_id": entry['tpmt3Id'],
                "amount": entry['amount'],
                "rrn": entry['rrn'] ?? "",
              });
              break;
          }
        }
      }

      List<Map<String, dynamic>> promotionsHeader = [];
      if (invHead.discHeaderManual != 0) {
        final promoHeader =
            await GetIt.instance<AppDatabase>().invoiceAppliedPromoDao.readByToinvId(invHead.docId!, null);
        List<Map<String, dynamic>> promoMaps =
            promoHeader.map((promo) => promo.promoToMapWithEmptyString(promo)).toList();
        promotionsHeader.addAll(promoMaps);
      }
      log("promotionsHeader - $promotionsHeader");

      List<Map<String, dynamic>> promotionsDetail = [];
      for (final tinv1 in invDet) {
        final appliedPromos = await GetIt.instance<AppDatabase>()
            .invoiceAppliedPromoDao
            .readByToinvIdAndTinv1Id(tinv1.toinvId!, tinv1.docId, null);

        List<Map<String, dynamic>> promoMaps = appliedPromos.map((promo) => promo.toMap()).toList();

        promotionsDetail.addAll(promoMaps);
      }
      log("promotionsDetail - $promotionsDetail");

      List<Map<String, dynamic>> approvals = [];
      final tinv6s = await GetIt.instance<AppDatabase>().approvalInvoiceDao.readByToinvId(invHead.docId!, null);
      log("tinv6s - $tinv6s");
      for (final tinv6 in tinv6s) {
        Map<String, dynamic> tinv6Maps = {
          "tousr_id": tinv6!.tousrId,
          "remarks": tinv6.remarks,
          "category": tinv6.category,
        };
        approvals.add(tinv6Maps);
      }

      final tinv7s = await GetIt.instance<AppDatabase>().downPaymentItemsDao.readByToinvId(invHead.docId!, null);
      log("tinv7s - $tinv7s");
      final List<Map<String, dynamic>> downPaymentItems = [];

      for (final tinv7 in tinv7s) {
        downPaymentItems.add({
          "docnum": invHead.docnum,
          "idnumber": tinv7!.idNumber,
          "toitm_id": tinv7.toitmId,
          "quantity": tinv7.quantity,
          "sellingprice": tinv7.sellingPrice.round(),
          "discprctg": 0,
          "discamount": 0,
          "totalamount": tinv7.totalAmount,
          "taxprctg": 0,
          "promotiontype": "",
          "promotionid": "",
          "remarks": tinv7.remarks ?? "",
          "edittime": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
          "cogs": 0,
          "tovat_id": tinv7.tovatId,
          "promotiontingkat": "",
          "promovoucherno": "",
          "includetax": tinv7.includeTax,
          "toven_id": tinv7.tovenId,
          "tbitm_id": tinv7.tbitmId,
          "qtybarcode": tinv7.quantity,
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
          "qtyconv": tinv7.quantity,
          "discprctgmember": 0.0,
          "discamountmember": 0.0,
          "tohem_id": tinv7.tohemId,
          "refpos2": tinv7.refpos2 ?? "",
          "promotion": []
        });
      }

      final List<String> docnums = [];
      final itemDP = await GetIt.instance<GetDownPaymentUseCase>().call();

      final dataToSend = {
        "tostr_id": invHead.tostrId,
        "docnum": invHead.docnum,
        "orderno": invHead.orderNo,
        "tocus_id": invHead.tocusId,
        "tohem_id": invHead.tohemId,
        "transdate": invHead.transDateTime!
            .add(Duration(hours: DateTime.now().timeZoneOffset.inHours))
            .toUtc()
            .toIso8601String(),
        "transtime": invHead.transDateTime!
            .add(Duration(hours: DateTime.now().timeZoneOffset.inHours))
            .toUtc()
            .toIso8601String(),
        "timezone": invHead.timezone,
        "remarks": invHead.remarks ?? "",
        "subtotal": (invHead.subTotal - invHead.discAmount + (invHead.discHeaderManual ?? 0)).round(),
        "discprctg": invHead.subTotal == 0
            ? 0
            : 100 *
                ((invHead.discHeaderManual ?? 0) /
                    (invHead.subTotal - invHead.discAmount + (invHead.discHeaderManual ?? 0))),
        "discamount": invHead.discAmount - (invHead.discHeaderPromo ?? 0),
        "discountcard": invHead.discountCard,
        "coupon": invHead.coupon,
        // "discountcoupon": invHead.discountCoupun,
        "discountcoupon": 0,
        "taxprctg": invHead.taxPrctg,
        "taxamount": double.parse(invHead.taxAmount.toStringAsFixed(2)),
        "addcost": invHead.addCost,
        "rounding": invHead.rounding,
        "grandtotal": invHead.grandTotal.round(),
        "changed": invHead.changed,
        "totalpayment": invHead.totalPayment.round() - invHead.changed,
        "tocsr_id": invHead.tocsrId,
        "toinv_tohem_id": invHead.toinvTohemId,
        "refpos1": invHead.refpos1,
        "invoice_item": invDetWithQtyBarcode.map((item) {
          if (itemDP != null && itemDP.toitmId == item['toitmId'] && item['quantity'] == -1) {
            docnums.add(item['refpos2']);
          }

          List<Map<String, dynamic>> filteredPromotions = promotionsDetail.where((promo) {
            return promo['tinv1docid'] == item['docId'];
          }).toList();
          return {
            "docnum": item['docnum'],
            "idnumber": item['idnumber'],
            "toitm_id": item['toitmId'],
            "quantity": item['quantity'],
            "sellingprice": item['sellingprice'].round(),
            "discprctg": item['discprctg'],
            "discamount": item['discamount'],
            "totalamount":
                ((item['quantity'] * item['sellingprice'] * (100 / (100 + item['taxprctg']))) - item['discamount'])
                    .round(),
            "taxprctg": item['taxprctg'],
            "promotiontype": item['promotiontype'],
            "promotionid": item['promotionid'],
            "remarks": item['remarks'] ?? "",
            "edittime": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(item['edittime'])),
            "cogs": item['cogs'],
            "tovat_id": item['tovatId'],
            "promotiontingkat": item['promotiontingkat'] ?? "",
            "promovoucherno": item['promovoucherno'] ?? "",
            "includetax": item['includetax'],
            "toven_id": item['tovenId'],
            "tbitm_id": item['tbitmId'],
            "qtybarcode": item['quantity'], // quantity barcode scanned x times
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
            "qtyconv": item['qtybarcode'] * item['quantity'], // qtybarcode * qtytbitm?
            "discprctgmember": 0.0,
            "discamountmember": 0.0,
            "tohem_id": (item['tohemId'] == "") ? invHead.salesTohemId : item['tohemId'],
            "refpos2": item['refpos2'],
            "refpos3": item['refpos3'],
            "promotion": filteredPromotions
          };
        }).toList(),
        "invoice_payment": invoicePayments,
        "promotion": promotionsHeader,
        "approval": approvals,
        "downpayment_docnums": docnums,
      };
      if (invHead.salesTohemId != "") {
        dataToSend["sales_tohem_id"] = invHead.salesTohemId;
      }
      if (tinv7s.isNotEmpty) {
        dataToSend["downpayment_item"] = downPaymentItems;
      }

      log("Data2Send: ${jsonEncode(dataToSend)}");

      Response response = await _dio.post(
        "$url/tenant-invoice/",
        data: dataToSend,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log("response - $response");

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        // log("Success Post");
        final invHeaderSuccess = InvoiceHeaderModel(
          docId: invHead.docId,
          createDate: invHead.createDate,
          updateDate: invHead.updateDate,
          tostrId: invHead.tostrId,
          docnum: invHead.docnum,
          orderNo: invHead.orderNo,
          tocusId: invHead.tocusId,
          tohemId: invHead.tohemId,
          transDateTime: invHead.transDateTime,
          timezone: invHead.timezone,
          remarks: invHead.remarks,
          subTotal: invHead.subTotal,
          discPrctg: invHead.discPrctg,
          discAmount: invHead.discAmount,
          discountCard: invHead.discountCard,
          coupon: invHead.coupon,
          discountCoupun: invHead.discountCoupun,
          taxPrctg: invHead.taxPrctg,
          taxAmount: invHead.taxAmount,
          addCost: invHead.addCost,
          rounding: invHead.rounding,
          grandTotal: invHead.grandTotal,
          changed: invHead.changed,
          totalPayment: invHead.totalPayment,
          tocsrId: invHead.tocsrId,
          docStatus: invHead.docStatus,
          sync: invHead.sync,
          syncCRM: invHead.syncCRM,
          toinvTohemId: invHead.toinvTohemId,
          refpos1: invHead.refpos1,
          refpos2: invHead.refpos2,
          tcsr1Id: invHead.tcsr1Id,
          discHeaderManual: invHead.discHeaderManual,
          discHeaderPromo: invHead.discHeaderPromo,
          syncToBos: response.data['docid'],
          paymentSuccess: invHead.paymentSuccess,
          salesTohemId: invHead.salesTohemId,
        );

        await GetIt.instance<AppDatabase>().invoiceHeaderDao.update(
              docId: invHead.docId!,
              data: invHeaderSuccess,
            );
      }
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<String> lockInvoice(String lockBy, List<String> docnums) async {
    try {
      token = prefs.getString('adminToken');
      POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) throw "Failed to retrieve POS Parameter";
      url = posParameterEntity.baseUrl;
      final String lockedByTocsr = posParameterEntity.tocsrId ?? "";

      String lockDateTime = DateTime.now().toIso8601String();

      final dataToSend = {
        "lockby": lockBy,
        "lockdatetime": "${lockDateTime}Z",
        "lockedbytocsr": lockedByTocsr,
        "docnums": docnums,
      };

      try {
        Response response = await _dio.put(
          "$url/tenant-lock-dp",
          data: dataToSend,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );
        log("Response - ${response.data}");
        return response.data['message'];
      } catch (e) {
        if (e is DioException) {
          // DioException contains the response even for errors
          if (e.response != null) {
            log("Error response status: ${e.response?.statusCode}");
            log("Error response data: ${e.response?.data}");
            return "${e.response?.data['errors'] ?? 'Unknown error'}";
          } else {
            log("Error without response: ${e.message}");
            return "${e.message}";
          }
        } else {
          log("Unexpected error: $e");
          return "Unexpected error: $e";
        }
      }
    } catch (e) {
      return "Error during lock invoice process: ${e.toString()}";
    }
  }

  Future<String> unlockInvoice(String unlockBy, List<String> docnums) async {
    try {
      token = prefs.getString('adminToken');
      POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) throw "Failed to retrieve POS Parameter";
      url = posParameterEntity.baseUrl;
      final String unlockedByTocsr = posParameterEntity.tocsrId ?? "";

      String unlockDateTime = DateTime.now().toIso8601String();

      final dataToSend = {
        "unlockby": unlockBy,
        "unlockdatetime": "${unlockDateTime}Z",
        "unlockedbytocsr": unlockedByTocsr,
        "docnums": docnums,
      };
      log("dataToSend - $dataToSend");

      Response response = await _dio.put(
        "$url/tenant-unlock-dp",
        data: dataToSend,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log("response - ${response.data['message']}");
      return response.data['message'];
    } catch (e) {
      return "Error during lock invoice process: ${e.toString()}";
    }
  }
}
