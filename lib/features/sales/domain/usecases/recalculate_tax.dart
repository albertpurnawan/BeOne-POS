// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/down_payment_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';

class RecalculateTaxUseCase implements UseCase<ReceiptEntity, ReceiptEntity> {
  RecalculateTaxUseCase();

  @override
  Future<ReceiptEntity> call({ReceiptEntity? params}) async {
    ReceiptItemEntity? dpItem = params!.receiptItems.where((element) => element.itemEntity.barcode == "99").firstOrNull;
    List<DownPaymentEntity> dps = params.downPayments ?? [];

    double dpAmount = dps.fold(0.0, (value, dp) => value + dp.amount);
    final double returnAmountGross = params.receiptItems
        .where((element) => element.refpos3 != null)
        .map((e) => e.totalGross)
        .fold<double>(0, (previousValue, element) => previousValue + element);
    final double returnAmountNet = params.receiptItems
        .where((element) => element.refpos3 != null)
        .map((e) => e.totalAmount)
        .fold<double>(0, (previousValue, element) => previousValue + element);
    final double returnTax = returnAmountNet - returnAmountGross;

    log("returnAmountNet: $returnAmountNet");
    log("returnAmountGross: $returnAmountGross");

    double subtotal = params.subtotal + dpAmount;
    double discHeaderManual = params.discHeaderManual ?? 0.0;
    double grandTotal = params.grandTotal + dpAmount;
    double discHprctg = (discHeaderManual) / (grandTotal - returnAmountNet);
    // double subtotalAfterHeaderDiscount = 0;
    double taxAfterHeaderDiscount = 0;
    double discAmountAfterHeaderDiscount = 0;
    double couponDiscPrctg = (params.couponDiscount) / (subtotal - (params.discAmount ?? 0) - returnAmountGross);

    log("params.subtotal ${params.subtotal}");
    log("discHeaderManual: $discHeaderManual");
    log("grandTotal: $grandTotal");
    log("discHprctg: $discHprctg");
    log("taxAfterHeaderDiscount: $taxAfterHeaderDiscount");
    log("discAmountAfterHeaderDiscount: $discAmountAfterHeaderDiscount");
    log("couponDiscPrctg: $couponDiscPrctg");

    for (final item in params.receiptItems.map((e) => e.copyWith())) {
      if (item.itemEntity.barcode != "99" && item.refpos3 == null) {
        item.discHeaderAmount =
            (((discHprctg * (item.totalAmount * (1 - couponDiscPrctg)))) * (100 / (item.itemEntity.taxRate + 100)));
        item.subtotalAfterDiscHeader =
            ((item.totalGross - (item.discAmount ?? 0)) * (1 - couponDiscPrctg)) - (item.discHeaderAmount ?? 0);

        item.taxAmount = item.subtotalAfterDiscHeader! * (item.itemEntity.taxRate / 100);
        // subtotalAfterHeaderDiscount += item.subtotalAfterDiscHeader!;
        taxAfterHeaderDiscount += item.taxAmount;
        discAmountAfterHeaderDiscount += (item.discAmount ?? 0) + (item.discHeaderAmount ?? 0);
      }

      log("item.discHeaderAmount ${item.discHeaderAmount}");
      log("item.subtotalAfterDiscHeader ${item.subtotalAfterDiscHeader}");
      log("item.taxAmount ${item.taxAmount}");
      log("taxAfterHeaderDiscount ${taxAfterHeaderDiscount}");
      log("item.discHeaderAmount ${item.discHeaderAmount}");
    }

    params.taxAmount = returnTax + taxAfterHeaderDiscount;
    // params.subtotal -= dpAmount;
    params.discAmount = discAmountAfterHeaderDiscount;
    params.discPrctg = (params.discAmount ?? 0) / (params.subtotal == 0 ? 1 : params.subtotal);
    params.grandTotal = params.subtotal - (params.discAmount ?? 0) - params.couponDiscount + params.taxAmount;

    log("{params.taxAmount}: ${params.taxAmount}");
    log("{params.subtotal}: ${params.subtotal}");
    log("{params.grandTotal}: ${params.grandTotal}");
    log("{params.discAmount}: ${params.discAmount}");
    log("{params.couponDiscount}: ${params.couponDiscount}");
    log("{params.discPrctg}: ${params.discPrctg}");

    return params;
  }
}
