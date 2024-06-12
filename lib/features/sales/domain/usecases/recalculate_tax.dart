import 'dart:developer';

import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/repository/receipt_repository.dart';

class RecalculateTaxUseCase implements UseCase<void, ReceiptEntity> {
  final ReceiptRepository _receiptRepository;

  RecalculateTaxUseCase(this._receiptRepository);

  @override
  Future<ReceiptEntity> call({ReceiptEntity? params}) async {
    log("Recalculate Tax Promo_Impl");
    double? discHeaderManual = params!.discHeaderManual ?? 0.0;
    double? discHeaderPromo = params.discHeaderPromo ?? 0.0;
    double subtotal = params.subtotal;
    double discHprctg = (discHeaderManual) / (subtotal - discHeaderPromo);
    double subtotalAfterDiscount = 0;
    double taxAfterDiscount = 0;

    for (final item in params.receiptItems.map((e) => e.copyWith())) {
      item.discHeaderAmount =
          discHprctg * (item.totalGross - (item.discAmount ?? 0));
      item.subtotalAfterDiscHeader = item.totalGross -
          (item.discAmount ?? 0) -
          (item.discHeaderAmount ?? 0);
      item.taxAmount =
          item.subtotalAfterDiscHeader! * (item.itemEntity.taxRate / 100);
      subtotalAfterDiscount += item.subtotalAfterDiscHeader!;
      taxAfterDiscount += item.taxAmount;
    }

    params.taxAmount = taxAfterDiscount;
    params.grandTotal = subtotalAfterDiscount + taxAfterDiscount;

    return params;
  }
}