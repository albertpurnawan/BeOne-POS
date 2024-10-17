// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_promo_topdi.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promo_topdi_applicability.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_promo_topdi_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_receipt_by_new_receipt_items.dart';

class HandlePromoTopdiUseCase implements UseCase<ReceiptEntity, HandlePromosUseCaseParams> {
  HandlePromoTopdiUseCase(this._getPromoTopdiHeaderAndDetailUseCase, this._checkPromoTopdiApplicabilityUseCase,
      this._applyPromoTopdiUseCase, this._recalculateReceiptUseCase);

  final GetPromoTopdiHeaderAndDetailUseCase _getPromoTopdiHeaderAndDetailUseCase;
  final CheckPromoTopdiApplicabilityUseCase _checkPromoTopdiApplicabilityUseCase;
  final ApplyPromoTopdiUseCase _applyPromoTopdiUseCase;
  final RecalculateReceiptUseCase _recalculateReceiptUseCase;

  @override
  Future<ReceiptEntity> call({HandlePromosUseCaseParams? params}) async {
    try {
      if (params == null) {
        throw "HandlePromoTopdiUseCase requires params";
      }
      // Get conditions
      final GetPromoTopdiHeaderAndDetailUseCaseResult topdiHeaderAndDetail =
          await _getPromoTopdiHeaderAndDetailUseCase.call(params: params.promo);

      // Check applicability
      final bool isApplicable = await _checkPromoTopdiApplicabilityUseCase.call(
          params: CheckPromoTopdiApplicabilityUseCaseParams(
              topdiHeaderAndDetail: topdiHeaderAndDetail, handlePromosUseCaseParams: params));
      if (!isApplicable) return params.receiptEntity;

      // Apply promo (pctg and amount)
      ReceiptEntity newReceipt = await _applyPromoTopdiUseCase.call(
          params: ApplyPromoTopdiUseCaseParams(
              topdiHeaderAndDetail: topdiHeaderAndDetail, handlePromosUseCaseParams: params));

      newReceipt = await _recalculateReceiptUseCase.call(params: newReceipt);
      return newReceipt;
    } catch (e) {
      rethrow;
    }
  }
}
