import 'dart:developer';

import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';

class ApplyRoundingUseCase implements UseCase<ReceiptEntity, ReceiptEntity> {
  final GetPosParameterUseCase _getPosParameterUseCase;
  final GetStoreMasterUseCase _getStoreMasterUseCase;

  ApplyRoundingUseCase(this._getPosParameterUseCase, this._getStoreMasterUseCase);

  @override
  Future<ReceiptEntity> call({ReceiptEntity? params}) async {
    try {
      if (params == null) throw "ApplyRoundingUseCase requires params";

      final POSParameterEntity? posParameterEntity = await _getPosParameterUseCase.call();
      if (posParameterEntity == null) {
        throw "POS Paramater not found when applying rounding";
      }
      final StoreMasterEntity? storeMasterEntity =
          await _getStoreMasterUseCase.call(params: posParameterEntity.tostrId);
      if (storeMasterEntity == null) {
        throw "Store master not found when applying rounding";
      }

      int roundingSetting = 1;
      if (storeMasterEntity.autoRounding != null && storeMasterEntity.autoRounding == 1) roundingSetting = 50;
      if (storeMasterEntity.roundingValue != null) {
        if (storeMasterEntity.roundingValue! >= 1) roundingSetting = storeMasterEntity.roundingValue!.round();
      }

      final double beforeRounding = params.subtotal - (params.discAmount ?? 0) + params.taxAmount;
      final double remainder = beforeRounding % roundingSetting;
      final double rounding = remainder == 0
          ? 0
          : remainder >= (roundingSetting / 2)
              ? roundingSetting - remainder
              : -1 * remainder;
      final double grandTotal = beforeRounding + rounding;

      // log("remainder $remainder");
      // log("beforeRounding $beforeRounding");
      // log("rounding $rounding");
      // log("grandtotal $grandTotal");

      return params.copyWith(grandTotal: grandTotal, rounding: rounding);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
