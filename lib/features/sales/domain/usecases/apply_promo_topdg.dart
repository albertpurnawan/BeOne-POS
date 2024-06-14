import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_group_item_header.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_promo_topdg_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class ApplyPromoTopdgUseCase
    implements UseCase<ReceiptEntity, ApplyPromoTopdgUseCaseParams> {
  ApplyPromoTopdgUseCase();

  @override
  Future<ReceiptEntity> call({ApplyPromoTopdgUseCaseParams? params}) async {
    try {
      if (params == null) throw "ApplyPromoTopdgUseCase requires params";

      final PromoDiskonGroupItemHeaderEntity topdg =
          params.topdgHeaderAndDetail.topdg;

      final SplitListResult<ReceiptItemEntity> splitListResult =
          Helpers.splitList<ReceiptItemEntity>(
              params.handlePromosUseCaseParams.receiptEntity.receiptItems,
              (p0) => params.topdgHeaderAndDetail.tpdg1
                  .where((e) => e.tocatId == p0.itemEntity.tocatId)
                  .isNotEmpty);
      final ReceiptEntity receiptEntity =
          params.handlePromosUseCaseParams.receiptEntity;
      final List<ReceiptItemEntity> receiptItemsWithinGroup =
          splitListResult.trueResult;
      final List<ReceiptItemEntity> otherReceiptItems =
          splitListResult.falseResult;

      // Handle disc by amount
      if (topdg.promoValue > 0) {
        // revert discount header

        // apply promo
        final double discValue = topdg.promoValue;
        final double discValuePctg = discValue /
            (receiptEntity.subtotal - (receiptEntity.discHeaderPromo ?? 0));
        final List<ReceiptItemEntity> newReceiptItems = [];
        for (final receiptItem
            in params.handlePromosUseCaseParams.receiptEntity.receiptItems) {
          final double thisDiscAmount = receiptItem.discAmount == null
              ? (discValuePctg * receiptItem.totalGross)
              : (discValuePctg *
                  (receiptItem.totalGross - receiptItem.discAmount!));

          newReceiptItems
              .add(ReceiptHelper.updateReceiptItemAggregateFields(receiptItem
                ..discAmount = receiptItem.discAmount == null
                    ? (discValuePctg * receiptItem.totalGross)
                    : receiptItem.discAmount! +
                        (discValuePctg *
                            (receiptItem.totalGross - receiptItem.discAmount!))
                ..promos = [
                  ...receiptItem.promos,
                  params.handlePromosUseCaseParams.promo!
                      .copyWith(discAmount: thisDiscAmount)
                ]));
        }

        return receiptEntity.copyWith(receiptItems: newReceiptItems, promos: [
          ...receiptEntity.promos,
          params.handlePromosUseCaseParams.promo!
        ]);
      } else {
        // Handle disc by pctg
        final double totalChainOfDiscountPctg = 1 -
            ((1 - (topdg.discount1 / 100)) *
                (1 - (topdg.discount2 / 100)) *
                (1 - (topdg.discount3 / 100)));

        final List<ReceiptItemEntity> newReceiptItemsWithinGroup = [];
        for (final receiptItem in receiptItemsWithinGroup) {
          final double thisDiscAmount = receiptItem.discAmount == null
              ? (totalChainOfDiscountPctg * receiptItem.totalGross)
              : (totalChainOfDiscountPctg *
                  (receiptItem.totalGross - receiptItem.discAmount!));
          final double discAmount = receiptItem.discAmount == null
              ? (totalChainOfDiscountPctg * receiptItem.totalGross)
              : receiptItem.discAmount! +
                  (totalChainOfDiscountPctg *
                      (receiptItem.totalGross - receiptItem.discAmount!));
          newReceiptItemsWithinGroup
              .add(ReceiptHelper.updateReceiptItemAggregateFields(receiptItem
                ..discAmount = discAmount
                ..promos = [
                  ...receiptItem.promos,
                  params.handlePromosUseCaseParams.promo!
                    ..discAmount = thisDiscAmount
                ]));
        }

        return receiptEntity.copyWith(
          receiptItems: [
            ...otherReceiptItems,
            ...newReceiptItemsWithinGroup,
          ],
          promos: [
            ...receiptEntity.promos,
            params.handlePromosUseCaseParams.promo!
          ],
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}

class ApplyPromoTopdgUseCaseParams {
  final GetPromoTopdgHeaderAndDetailUseCaseResult topdgHeaderAndDetail;
  final HandlePromosUseCaseParams handlePromosUseCaseParams;

  ApplyPromoTopdgUseCaseParams(
      {required this.topdgHeaderAndDetail,
      required this.handlePromosUseCaseParams});
}
