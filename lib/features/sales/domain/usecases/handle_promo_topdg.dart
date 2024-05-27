// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_promo_topdg.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promo_topdg_applicability.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_promo_topdg_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_receipt_by_new_receipt_items.dart';

class HandlePromoTopdgUseCase
    implements UseCase<ReceiptEntity, HandlePromosUseCaseParams> {
  HandlePromoTopdgUseCase(
      this._getPromoTopdgHeaderAndDetailUseCase,
      this._checkPromoTopdgApplicabilityUseCase,
      this._applyPromoTopdgUseCase,
      this._recalculateReceiptUseCase);

  final GetPromoTopdgHeaderAndDetailUseCase
      _getPromoTopdgHeaderAndDetailUseCase;
  final CheckPromoTopdgApplicabilityUseCase
      _checkPromoTopdgApplicabilityUseCase;
  final ApplyPromoTopdgUseCase _applyPromoTopdgUseCase;
  final RecalculateReceiptUseCase _recalculateReceiptUseCase;

  @override
  Future<ReceiptEntity> call({HandlePromosUseCaseParams? params}) async {
    try {
      if (params == null) {
        throw "HandlePromoTopdgUseCase requires params";
      }
      // Get conditions
      final GetPromoTopdgHeaderAndDetailUseCaseResult topdgHeaderAndDetail =
          await _getPromoTopdgHeaderAndDetailUseCase.call(params: params.promo);

      // Check applicability
      final bool isApplicable = await _checkPromoTopdgApplicabilityUseCase.call(
          params: CheckPromoTopdgApplicabilityUseCaseParams(
              topdgHeaderAndDetail: topdgHeaderAndDetail,
              handlePromosUseCaseParams: params));
      log(isApplicable.toString());
      if (!isApplicable) return params.receiptEntity;

      // Apply promo (pctg and amount)
      ReceiptEntity newReceipt = await _applyPromoTopdgUseCase.call(
          params: ApplyPromoTopdgUseCaseParams(
              topdgHeaderAndDetail: topdgHeaderAndDetail,
              handlePromosUseCaseParams: params));

      newReceipt = await _recalculateReceiptUseCase.call(params: newReceipt);
      return newReceipt;
    } catch (e) {
      rethrow;
    }
  }
}
