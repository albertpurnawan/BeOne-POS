import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';

class RecalculateReceiptUseCase implements UseCase<ReceiptEntity, ReceiptEntity> {
  RecalculateReceiptUseCase();

  @override
  Future<ReceiptEntity> call({ReceiptEntity? params}) async {
    try {
      if (params == null) throw "RecalculateReceiptUseCase requires params";

      double subtotal = 0;
      double discAmount = 0;
      double discHeaderPromo = 0;
      double taxAmount = 0;
      double grandTotal = 0;

      params.receiptItems.forEach((element) {
        subtotal += element.totalGross;
        discAmount += (element.discAmount ?? 0) + (element.discHeaderAmount ?? 0);
        discHeaderPromo += element.discAmount ?? 0;
        taxAmount += element.taxAmount;

        // update
        element.discPrctg = ((element.discAmount ?? 0) / element.totalGross) * 100;
      });

      grandTotal = subtotal - discAmount + taxAmount;

      final ReceiptEntity newReceipt = params.copyWith(
        subtotal: subtotal,
        discAmount: discAmount,
        discHeaderPromo: discHeaderPromo,
        discPrctg: subtotal == 0 ? 0 : (discAmount / subtotal) * 100,
        taxAmount: taxAmount,
        grandTotal: grandTotal,
      );

      return newReceipt;
    } catch (e) {
      rethrow;
    }
  }
}
