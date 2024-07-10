import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_item_header.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_promo_topdi_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class ApplyPromoTopdiUseCase implements UseCase<ReceiptEntity, ApplyPromoTopdiUseCaseParams> {
  ApplyPromoTopdiUseCase();

  @override
  Future<ReceiptEntity> call({ApplyPromoTopdiUseCaseParams? params}) async {
    try {
      if (params == null) throw "ApplyPromoTopdiUseCase requires params";

      final PromoDiskonItemHeaderEntity topdi = params.topdiHeaderAndDetail.topdi;

      final ReceiptEntity receiptEntity = params.handlePromosUseCaseParams.receiptEntity;

      final SplitListResult<ReceiptItemEntity> splitListResult = switch (topdi.promoType) {
        1 => Helpers.splitList<ReceiptItemEntity>(
            receiptEntity.receiptItems,
            (receiptItem) => params.topdiHeaderAndDetail.tpdi1
                .where((e) =>
                    e.toitmId == receiptItem.itemEntity.toitmId &&
                    e.priceFrom! <= receiptItem.totalGross &&
                    e.priceTo! >= receiptItem.totalGross)
                .isNotEmpty),
        2 => Helpers.splitList<ReceiptItemEntity>(
            receiptEntity.receiptItems,
            (receiptItem) => params.topdiHeaderAndDetail.tpdi1
                .where((e) =>
                    e.toitmId == receiptItem.itemEntity.toitmId &&
                    e.qtyFrom! <= receiptItem.quantity &&
                    e.qtyTo! >= receiptItem.quantity)
                .isNotEmpty),
        3 || 4 => Helpers.splitList<ReceiptItemEntity>(
            receiptEntity.receiptItems,
            (receiptItem) =>
                params.topdiHeaderAndDetail.tpdi1.where((e) => e.toitmId == receiptItem.itemEntity.toitmId).isNotEmpty),
        _ => SplitListResult([], [])
      };

      final List<ReceiptItemEntity> matchedReceiptItems = splitListResult.trueResult;
      final List<ReceiptItemEntity> otherReceiptItems = splitListResult.falseResult;

      // Handle disc by amount
      if (topdi.promoValue > 0) {
        // revert discount header

        // apply promo
        final double discValuePctg = topdi.promoValue / (receiptEntity.subtotal - (receiptEntity.discHeaderPromo ?? 0));
        final List<ReceiptItemEntity> newReceiptItems = [];
        for (final receiptItem in params.handlePromosUseCaseParams.receiptEntity.receiptItems) {
          final double thisDiscAmount = receiptItem.discAmount == null
              ? (discValuePctg * receiptItem.totalGross)
              : (discValuePctg * (receiptItem.totalGross - receiptItem.discAmount!));
          final double discAmount = receiptItem.discAmount == null
              ? (discValuePctg * receiptItem.totalGross)
              : receiptItem.discAmount! + (discValuePctg * (receiptItem.totalGross - receiptItem.discAmount!));

          newReceiptItems.add(ReceiptHelper.updateReceiptItemAggregateFields(receiptItem
            ..discAmount = discAmount
            ..promos = [
              ...receiptItem.promos,
              params.handlePromosUseCaseParams.promo!.copyWith(discAmount: thisDiscAmount)
            ]));
        }

        return receiptEntity.copyWith(
            receiptItems: newReceiptItems, promos: [...receiptEntity.promos, params.handlePromosUseCaseParams.promo!]);
      } else {
        // Handle disc by pctg
        final double totalChainOfDiscountPctg =
            1 - ((1 - (topdi.discount1 / 100)) * (1 - (topdi.discount2 / 100)) * (1 - (topdi.discount3 / 100)));

        final List<ReceiptItemEntity> newMatchedReceiptItems = [];
        for (final receiptItem in matchedReceiptItems) {
          final double thisDiscAmount = receiptItem.discAmount == null
              ? (totalChainOfDiscountPctg * receiptItem.totalGross)
              : (totalChainOfDiscountPctg * (receiptItem.totalGross - receiptItem.discAmount!));
          final double discAmount = receiptItem.discAmount == null
              ? (totalChainOfDiscountPctg * receiptItem.totalGross)
              : receiptItem.discAmount! +
                  (totalChainOfDiscountPctg * (receiptItem.totalGross - receiptItem.discAmount!));
          newMatchedReceiptItems.add(ReceiptHelper.updateReceiptItemAggregateFields(receiptItem
            ..discAmount = discAmount
            ..promos = [
              ...receiptItem.promos,
              params.handlePromosUseCaseParams.promo!.copyWith(discAmount: thisDiscAmount)
            ]));
        }

        return receiptEntity.copyWith(
          receiptItems: [
            ...otherReceiptItems,
            ...newMatchedReceiptItems,
          ],
          promos: [...receiptEntity.promos, params.handlePromosUseCaseParams.promo!],
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}

class ApplyPromoTopdiUseCaseParams {
  final GetPromoTopdiHeaderAndDetailUseCaseResult topdiHeaderAndDetail;
  final HandlePromosUseCaseParams handlePromosUseCaseParams;

  ApplyPromoTopdiUseCaseParams({required this.topdiHeaderAndDetail, required this.handlePromosUseCaseParams});
}
