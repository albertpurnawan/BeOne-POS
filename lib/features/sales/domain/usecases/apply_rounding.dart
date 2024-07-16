import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';

class ApplyRoundingUseCase implements UseCase<ReceiptEntity, ReceiptEntity> {
  ApplyRoundingUseCase();

  @override
  Future<ReceiptEntity> call({ReceiptEntity? params}) async {
    try {
      if (params == null) throw "ApplyRoundingUseCase requires params";
      final double beforeRounding = params.subtotal - (params.discAmount ?? 0) + params.taxAmount;
      final double rounding = beforeRounding % 50 > 0 ? 50 - (beforeRounding % 50) : 0;
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
