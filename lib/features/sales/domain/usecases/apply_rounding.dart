import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';

class ApplyRoundingUseCase implements UseCase<ReceiptEntity, ReceiptEntity> {
  ApplyRoundingUseCase();

  @override
  Future<ReceiptEntity> call({ReceiptEntity? params}) async {
    try {
      if (params == null) throw "ApplyRoundingUseCase requires params";
      final double beforeRounding = params.subtotal - (params.discAmount ?? 0) + params.taxAmount;
      final double remainder = beforeRounding % 50;
      final double rounding = remainder == 0
          ? 0
          : remainder >= 25
              ? 50 - (beforeRounding % 50)
              : -1 * remainder;
      final double grandTotal = beforeRounding + rounding;

      // log("beforeRounding $beforeRounding");
      // log("rounding $rounding");
      // log("grandtotal $grandTotal");

      return params.copyWith(grandTotal: grandTotal, rounding: rounding);
    } catch (e) {
      rethrow;
    }
  }
}
