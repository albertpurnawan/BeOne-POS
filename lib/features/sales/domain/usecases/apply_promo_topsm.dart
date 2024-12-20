import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_spesial_multi_item_detail.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_spesial_multi_item_header.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_promo_topsm_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class ApplyTopsmUseCase implements UseCase<ReceiptEntity, ApplyPromoTopsmUseCaseParams> {
  ApplyTopsmUseCase();

  @override
  Future<ReceiptEntity> call({ApplyPromoTopsmUseCaseParams? params}) async {
    try {
      if (params == null) throw "ApplyPromoTopsmUseCase requires params";

      final PromoSpesialMultiItemHeaderEntity topsm = params.topsmHeaderAndDetail.topsm;
      final List<PromoSpesialMultiItemDetailEntity> tpsm1s = params.topsmHeaderAndDetail.tpsm1;
      final ReceiptEntity receiptEntity = params.handlePromosUseCaseParams.receiptEntity;

      final List<ReceiptItemEntity> newReceiptItems = [];

      if (topsm.condition == 0) {
        for (final receiptItem in receiptEntity.receiptItems) {
          final matchingPromo = tpsm1s
                  .where(
                    (tpsm1) => tpsm1.toitmId == receiptItem.itemEntity.toitmId,
                  )
                  .isNotEmpty
              ? tpsm1s.firstWhere((tpsm1) => tpsm1.toitmId == receiptItem.itemEntity.toitmId)
              : null;

          if (matchingPromo != null) {
            final itemEntity = receiptItem.itemEntity;
            final quantity = receiptItem.quantity;
            double discount = 0;

            final promoPrice = itemEntity.includeTax == 1
                ? (matchingPromo.price * (100 / (100 + itemEntity.taxRate)))
                : matchingPromo.price;

            if (quantity >= matchingPromo.qtyFrom && quantity <= matchingPromo.qtyTo) {
              discount = (quantity * itemEntity.dpp) - (promoPrice * quantity);
            } else if (quantity > matchingPromo.qtyTo) {
              int fullSets = (matchingPromo.qtyTo ~/ 1);
              double remainderItems = quantity - matchingPromo.qtyTo;
              double expectedSubtotal = (fullSets * promoPrice) + (remainderItems * itemEntity.price);
              double actualTotalPrice = itemEntity.price * quantity;
              discount = actualTotalPrice - expectedSubtotal;
            }

            final double discValuePctg = discount / (receiptItem.totalGross - (receiptEntity.discHeaderPromo ?? 0));
            double thisDiscAmount = receiptItem.discAmount == null
                ? (discValuePctg * receiptItem.totalGross)
                : (discValuePctg * (receiptItem.totalGross - (receiptItem.discAmount ?? 0)));
            double discAmount = receiptItem.discAmount == null
                ? (discValuePctg * receiptItem.totalGross)
                : receiptItem.discAmount! + (discValuePctg * (receiptItem.totalGross - (receiptItem.discAmount ?? 0)));

            if (matchingPromo.price * quantity > quantity * itemEntity.dpp) {
              discAmount = 0;
              thisDiscAmount = 0;
            }

            newReceiptItems.add(ReceiptHelper.updateReceiptItemAggregateFields(receiptItem
              ..discAmount = discAmount
              ..promos = [
                ...receiptItem.promos,
                params.handlePromosUseCaseParams.promo!.copyWith(discAmount: thisDiscAmount)
              ]));
          } else {
            newReceiptItems.add(receiptItem);
          }
        }

        return receiptEntity.copyWith(
          receiptItems: newReceiptItems,
          promos: [...receiptEntity.promos, params.handlePromosUseCaseParams.promo!],
        );
      } else {
        // condition == 1
        bool allItemsExist = tpsm1s.every(
          (promoItem) => receiptEntity.receiptItems.any(
            (receiptItem) => receiptItem.itemEntity.toitmId == promoItem.toitmId,
          ),
        );

        if (allItemsExist) {
          for (ReceiptItemEntity receiptItem in receiptEntity.receiptItems) {
            final promoItem = tpsm1s
                    .where(
                      (tpsm1) => tpsm1.toitmId == receiptItem.itemEntity.toitmId,
                    )
                    .isNotEmpty
                ? tpsm1s.firstWhere((tpsm1) => tpsm1.toitmId == receiptItem.itemEntity.toitmId)
                : null;

            if (promoItem != null) {
              final quantity = receiptItem.quantity;
              double discount = 0;
              final promoPrice = receiptItem.itemEntity.includeTax == 1
                  ? (promoItem.price * (100 / (100 + receiptItem.itemEntity.taxRate)))
                  : promoItem.price;

              if (quantity >= promoItem.qtyFrom && quantity <= promoItem.qtyTo) {
                discount = (quantity * receiptItem.itemEntity.price) - (promoPrice * quantity);
              } else if (quantity > promoItem.qtyTo) {
                int fullSets = (promoItem.qtyTo ~/ 1);
                double remainderItems = (promoItem.qtyTo - ((promoItem.qtyTo / 1).floor() * 1));
                double expectedSubtotal = (fullSets * promoPrice) + (remainderItems * receiptItem.itemEntity.price);
                double actualTotalPrice = receiptItem.itemEntity.price * promoItem.qtyTo;
                discount = actualTotalPrice - expectedSubtotal;
              }
              final double thisDiscAmount =
                  receiptItem.discAmount == null ? discount : (receiptItem.totalGross - discount);

              newReceiptItems.add(ReceiptHelper.updateReceiptItemAggregateFields(receiptItem
                ..discAmount = discount
                ..promos = [
                  ...receiptItem.promos,
                  params.handlePromosUseCaseParams.promo!.copyWith(discAmount: thisDiscAmount)
                ]));
            } else {
              newReceiptItems.add(receiptItem);
            }
          }
          return receiptEntity.copyWith(
            receiptItems: newReceiptItems,
            promos: [...receiptEntity.promos, params.handlePromosUseCaseParams.promo!],
          );
        }
      }

      return receiptEntity.copyWith();
    } catch (e) {
      rethrow;
    }
  }
}

class ApplyPromoTopsmUseCaseParams {
  final GetPromoTopSmHeaderAndDetailUseCaseResult topsmHeaderAndDetail;
  final HandlePromosUseCaseParams handlePromosUseCaseParams;

  ApplyPromoTopsmUseCaseParams({required this.topsmHeaderAndDetail, required this.handlePromosUseCaseParams});
}
