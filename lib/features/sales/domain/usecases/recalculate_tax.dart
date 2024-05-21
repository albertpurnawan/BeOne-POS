import 'dart:developer';

import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/repository/receipt_repository.dart';

class RecalculateTaxUseCase implements UseCase<void, ReceiptEntity> {
  final ReceiptRepository _receiptRepository;

  RecalculateTaxUseCase(this._receiptRepository);

  @override
  Future<ReceiptEntity> call({ReceiptEntity? params}) async {
    log("Recalculate Tax Promo Usecase");
    double? discHeaderManual = params!.discHeaderManual ?? 0.0;
    double? discHeaderPromo = params.discHeaderPromo ?? 0.0;
    double subtotal = params.subtotal;
    double discHprctg = (discHeaderManual + discHeaderPromo) / subtotal;
    double subtotalAfterDiscount = 0;
    double taxAfterDiscount = 0;

    for (final item in params.receiptItems) {
      item.discHeaderAmount = discHprctg * item.totalGross;
      item.subtotalAfterDiscHeader =
          (item.totalGross) - (item.discHeaderAmount ?? 0);
      item.taxAmount =
          item.subtotalAfterDiscHeader! * (item.itemEntity.taxRate / 100);
      subtotalAfterDiscount += item.subtotalAfterDiscHeader!;
      taxAfterDiscount += item.taxAmount;
    }
    // params.subtotal = subtotalAfterDiscount;
    params.taxAmount = taxAfterDiscount;
    params.grandTotal = subtotalAfterDiscount + taxAfterDiscount;

    return params;
  }
}
