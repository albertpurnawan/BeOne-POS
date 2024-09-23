// ignore_for_file: public_member_api_docs, sort_constructors_first
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

    double discHeaderManual = params.discHeaderManual ?? 0.0;
    double grandTotal = params.grandTotal;
    double discHprctg = (discHeaderManual) / (grandTotal);
    // double subtotalAfterHeaderDiscount = 0;
    double taxAfterHeaderDiscount = 0;
    double discAmountAfterHeaderDiscount = 0;
    double couponDiscPrctg = (params.couponDiscount) / (params.subtotal - (params.discAmount ?? 0));

    for (final item in params.receiptItems.map((e) => e.copyWith())) {
      if (item.itemEntity.barcode != "99") {
        item.discHeaderAmount =
            (((discHprctg * (item.totalAmount * (1 - couponDiscPrctg)))) * (100 / (item.itemEntity.taxRate + 100)));
      }
      item.subtotalAfterDiscHeader =
          ((item.totalGross - (item.discAmount ?? 0)) * (1 - couponDiscPrctg)) - (item.discHeaderAmount ?? 0);

      item.taxAmount = item.subtotalAfterDiscHeader! * (item.itemEntity.taxRate / 100);
      // subtotalAfterHeaderDiscount += item.subtotalAfterDiscHeader!;
      taxAfterHeaderDiscount += item.taxAmount;
      discAmountAfterHeaderDiscount += (item.discAmount ?? 0) + (item.discHeaderAmount ?? 0);
    }

    params.taxAmount = taxAfterHeaderDiscount;
    params.subtotal -= dpAmount;
    params.grandTotal = params.subtotal + taxAfterHeaderDiscount;
    params.discAmount = discAmountAfterHeaderDiscount;
    params.discPrctg = (params.discAmount ?? 0) / (params.subtotal == 0 ? 1 : params.subtotal);

    return params;
  }
}
