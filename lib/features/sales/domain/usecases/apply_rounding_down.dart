import 'dart:developer';

import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';

class ApplyRoundingDownUseCase implements UseCase<ReceiptEntity, ReceiptEntity> {
  @override
  Future<ReceiptEntity> call({ReceiptEntity? params}) async {
    try {
      if (params == null) throw "ApplyRoundingDownUseCase requires params";
      int roundingSetting = 1000;
      final double beforeRounding =
          params.subtotal - (params.discAmount ?? 0) - params.couponDiscount + params.taxAmount;

      final double remainder = beforeRounding % roundingSetting;
      final double rounding = remainder == 0 ? 0 : -1 * remainder;
      final double grandTotal = beforeRounding + rounding;
      log("rounding - $rounding - grandTotal - $grandTotal");
      return params.copyWith(grandTotal: grandTotal, rounding: rounding);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
