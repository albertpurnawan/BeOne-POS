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

    double dpAmount = dps.where((dp) => dp.isSelected == true).fold(0.0, (value, dp) => value + dp.amount);
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
    }

    params.taxAmount = returnTax + taxAfterHeaderDiscount;
    // params.subtotal -= dpAmount;
    params.discAmount = discAmountAfterHeaderDiscount;
    params.discPrctg = (params.discAmount ?? 0) / (params.subtotal == 0 ? 1 : params.subtotal);
    params.rounding *= (1 - discHprctg);
    params.grandTotal =
        params.subtotal - (params.discAmount ?? 0) - params.couponDiscount + params.taxAmount + params.rounding;

    return params;
  }
}
