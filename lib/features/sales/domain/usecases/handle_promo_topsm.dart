import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_promo_topsm.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promo_topsm_applicability.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_promo_topsm_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_receipt_by_new_receipt_items.dart';

class HandlePromoSpesialMultiItemUseCase implements UseCase<ReceiptEntity, HandlePromosUseCaseParams> {
  HandlePromoSpesialMultiItemUseCase(
    this._getPromoTopSmHeaderAndDetailUseCase,
    this._checkPromoTopsmApplicabilityUseCase,
    this._applyTopsmUseCase,
    this._recalculateReceiptUseCase,
  );

  final GetPromoTopSmHeaderAndDetailUseCase _getPromoTopSmHeaderAndDetailUseCase;
  final CheckPromoTopsmApplicabilityUseCase _checkPromoTopsmApplicabilityUseCase;
  final ApplyTopsmUseCase _applyTopsmUseCase;
  final RecalculateReceiptUseCase _recalculateReceiptUseCase;

  @override
  Future<ReceiptEntity> call({HandlePromosUseCaseParams? params}) async {
    try {
      if (params == null) throw "HandlePromoSpesialMultiItemUseCase requires params";
      // Get conditions
      final GetPromoTopSmHeaderAndDetailUseCaseResult topsmHeaderAndDetail =
          await _getPromoTopSmHeaderAndDetailUseCase.call(params: params.promo);

      // Check applicability
      final bool isApplicable = await _checkPromoTopsmApplicabilityUseCase.call(
          params: CheckPromoTopsmApplicabilityUseCaseParams(
              topsmHeaderAndDetail: topsmHeaderAndDetail, handlePromosUseCaseParams: params));
      // log(isApplicable.toString());
      if (!isApplicable) return params.receiptEntity;

      // Apply promo (pctg and amount)
      ReceiptEntity newReceipt = await _applyTopsmUseCase.call(
          params: ApplyPromoTopsmUseCaseParams(
              topsmHeaderAndDetail: topsmHeaderAndDetail, handlePromosUseCaseParams: params));
      newReceipt = await _recalculateReceiptUseCase.call(params: newReceipt);
      return newReceipt;
    } catch (e) {
      rethrow;
    }
  }
}
