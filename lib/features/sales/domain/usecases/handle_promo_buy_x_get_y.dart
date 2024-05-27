// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pos_fe/core/resources/promotion_detail.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_header.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_buy_x_get_y_applicability.dart';

class HandlePromoBuyXGetYUseCase
    implements UseCase<ReceiptEntity, HandlePromoBuyXGetYUseCaseParams> {
  HandlePromoBuyXGetYUseCase();

  @override
  Future<ReceiptEntity> call({HandlePromoBuyXGetYUseCaseParams? params}) async {
    try {
      if (params == null) throw "HandlePromoBuyXGetYUseCase requires params";
      final List<String> itemXBarcodes = params.existingReceiptItemXs
          .map((e) => e.itemEntity.barcode)
          .toList();
      final List<String> itemYBarcodes =
          params.conditionAndItemYs.map((e) => e.itemEntity.barcode).toList();
      final List<ReceiptItemEntity> otherReceiptItems = params
          .receiptEntity.receiptItems
          .where((element) =>
              !itemYBarcodes.contains(element.itemEntity.barcode) &&
              !itemXBarcodes.contains(element.itemEntity.barcode))
          .toList();
      final List<ReceiptItemEntity> existingReceiptItemXs = [
        ...params.existingReceiptItemXs
      ];
      final List<ReceiptItemEntity> existingReceiptItemYs = params
          .receiptEntity.receiptItems
          .where((e) => itemYBarcodes.contains(e.itemEntity.barcode))
          .toList();

      // Handle X
      for (final existingReceiptItemX in existingReceiptItemXs) {
        bool promoExist = false;
        existingReceiptItemX.promos = existingReceiptItemX.promos.map((e) {
          if (e.promoId == params.promo.docId) {
            promoExist = true;
            return e
              ..promotionDetails = PromoBuyXGetYDetails(
                applyCount:
                    (e.promotionDetails as PromoBuyXGetYDetails).applyCount + 1,
                xGroups: [],
                yGroups: [],
              );
          }
          return e;
        }).toList();

        if (!promoExist) {
          existingReceiptItemX.promos.add(params.promo
            ..promotionDetails =
                PromoBuyXGetYDetails(applyCount: 1, xGroups: [], yGroups: []));
        }
      }

      // Handle Y
      final List<ReceiptItemEntity> receiptItemYs = [];
      for (final conditionAndItemY in params.conditionAndItemYs) {
        final existingReceiptItemY = existingReceiptItemYs.where((e) =>
            e.itemEntity.barcode == conditionAndItemY.itemEntity.barcode);

        if (existingReceiptItemY.isEmpty) {
          final double discAmount = (conditionAndItemY.itemEntity.dpp -
                  conditionAndItemY
                      .promoBuyXGetYGetConditionEntity.sellingPrice) *
              conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity *
              conditionAndItemY.multiply;
          receiptItemYs.add(
            ReceiptHelper.updateReceiptItemAggregateFields(
                ReceiptHelper.convertItemEntityToReceiptItemEntity(
                    conditionAndItemY.itemEntity,
                    conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity *
                        conditionAndItemY.multiply)
                  ..discAmount = discAmount
                  ..discPrctg = 0
                  ..promos = [
                    params.promo.copyWith(
                        promotionDetails: PromoBuyXGetYDetails(
                            applyCount: 1, xGroups: [], yGroups: []),
                        discAmount: discAmount)
                  ]),
          );
        } else {
          final double thisDiscAmount = existingReceiptItemY.first.discAmount ==
                  null
              ? (existingReceiptItemY.first.itemEntity.dpp -
                      conditionAndItemY
                          .promoBuyXGetYGetConditionEntity.sellingPrice) *
                  conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity *
                  conditionAndItemY.multiply
              : ((existingReceiptItemY.first.itemEntity.dpp -
                      conditionAndItemY
                          .promoBuyXGetYGetConditionEntity.sellingPrice) *
                  conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity *
                  conditionAndItemY.multiply);
          final double discAmount = existingReceiptItemY.first.discAmount ==
                  null
              ? (existingReceiptItemY.first.itemEntity.dpp -
                      conditionAndItemY
                          .promoBuyXGetYGetConditionEntity.sellingPrice) *
                  conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity *
                  conditionAndItemY.multiply
              : existingReceiptItemY.first.discAmount! +
                  ((existingReceiptItemY.first.itemEntity.dpp -
                          conditionAndItemY
                              .promoBuyXGetYGetConditionEntity.sellingPrice) *
                      conditionAndItemY
                          .promoBuyXGetYGetConditionEntity.quantity *
                      conditionAndItemY.multiply);

          List<PromotionsEntity> finalPromos = [];
          if (existingReceiptItemY.first.promos
              .where((element) => element.promoId == params.promo.promoId)
              .isEmpty) {
            finalPromos = [
              ...existingReceiptItemY.first.promos,
              params.promo.copyWith(
                  discAmount: thisDiscAmount,
                  promotionDetails: PromoBuyXGetYDetails(
                      applyCount: 1, xGroups: [], yGroups: []))
            ];
          } else {
            finalPromos = existingReceiptItemY.first.promos.map((e) {
              if (e.promoId == params.promo.promoId) {
                return e.copyWith(
                    discAmount: thisDiscAmount,
                    promotionDetails:
                        ((e.promotionDetails as PromoBuyXGetYDetails)
                          ..applyCount += 1));
              }

              return e;
            }).toList();
          }

          receiptItemYs.add(
            ReceiptHelper.updateReceiptItemAggregateFields(
                existingReceiptItemY.first.copyWith(
              quantity: existingReceiptItemY.first.quantity +
                  conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity *
                      conditionAndItemY.multiply,
              discAmount: discAmount,
              promos: finalPromos,
            )),
          );
        }
      }

      return params.receiptEntity.copyWith(
        receiptItems: [
          ...otherReceiptItems,
          ...existingReceiptItemXs,
          ...receiptItemYs
        ],
        promos: params.receiptEntity.promos
                .map((e) => e.promoId)
                .contains(params.promo.promoId)
            ? params.receiptEntity.promos.map((e) {
                if (e.promoId == params.promo.promoId) {
                  return e
                    ..promotionDetails =
                        ((e.promotionDetails as PromoBuyXGetYDetails)
                          ..applyCount += 1);
                }

                return e;
              }).toList()
            : [...params.receiptEntity.promos, params.promo],
      );
    } catch (e) {
      rethrow;
    }
  }
}

class HandlePromoBuyXGetYUseCaseParams {
  final ReceiptItemEntity receiptItemEntity;
  final ReceiptEntity receiptEntity;
  final PromotionsEntity promo;
  final PromoBuyXGetYHeaderEntity? toprb;
  final List<PromoBuyXGetYBuyConditionAndItemEntity> conditionAndItemXs;
  final List<PromoBuyXGetYGetConditionAndItemEntity> conditionAndItemYs;
  final List<ReceiptItemEntity> existingReceiptItemXs;

  HandlePromoBuyXGetYUseCaseParams({
    required this.receiptItemEntity,
    required this.receiptEntity,
    required this.promo,
    required this.toprb,
    required this.conditionAndItemXs,
    required this.conditionAndItemYs,
    required this.existingReceiptItemXs,
  });
}
