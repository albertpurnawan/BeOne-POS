import 'dart:developer';

import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';

class ApplyManualRoundingUseCase implements UseCase<ReceiptEntity, ReceiptEntity> {
  RoundingMode roundingMode;

  ApplyManualRoundingUseCase({required this.roundingMode});

  @override
  Future<ReceiptEntity> call({ReceiptEntity? params, double? amount}) async {
    try {
      if (params == null) throw "ApplyManualRoundingUseCase requires params";

      int roundingSetting = 1000;
      final double beforeRounding =
          params.subtotal - (params.discAmount ?? 0) - params.couponDiscount + params.taxAmount;

      final double remainder = beforeRounding % roundingSetting;

      double rounding;
      if (roundingMode == RoundingMode.down) {
        rounding = remainder == 0 ? 0 : -1 * remainder;
      } else if (roundingMode == RoundingMode.up) {
        rounding = remainder == 0 ? 0 : roundingSetting - remainder;
      } else {
        rounding = 0;
      }

      final double grandTotal = beforeRounding + rounding;
      log("rounding - $rounding - grandTotal - $grandTotal");
      return params.copyWith(grandTotal: grandTotal, rounding: rounding);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

enum RoundingMode {
  up,
  down,
}
