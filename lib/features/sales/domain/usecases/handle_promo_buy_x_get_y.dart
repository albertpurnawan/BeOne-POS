// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:pos_fe/core/resources/promotion_detail.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_header.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_buy_x_get_y_applicability.dart';

class HandlePromoBuyXGetYUseCase implements UseCase<ReceiptEntity, HandlePromoBuyXGetYUseCaseParams> {
  HandlePromoBuyXGetYUseCase();

  @override
  Future<ReceiptEntity> call({HandlePromoBuyXGetYUseCaseParams? params}) async {
    try {
      if (params == null) throw "HandlePromoBuyXGetYUseCase requires params";
      final List<String> itemXBarcodes = params.existingReceiptItemXs.map((e) => e.itemEntity.barcode).toList();
      final List<String> itemYBarcodes = params.conditionAndItemYs.map((e) => e.itemEntity.barcode).toList();
      final List<ReceiptItemEntity> otherReceiptItems = params.receiptEntity.receiptItems
          .where((element) =>
              !itemYBarcodes.contains(element.itemEntity.barcode) &&
              !itemXBarcodes.contains(element.itemEntity.barcode))
          .toList();
      final List<ReceiptItemEntity> existingReceiptItemXs = [...params.existingReceiptItemXs];
      final List<ReceiptItemEntity> existingReceiptItemYs = params.receiptEntity.receiptItems
          .where((e) => itemYBarcodes.contains(e.itemEntity.barcode))
          .map((e) => e.copyWith())
          .toList();

      // Handle X
      for (final existingReceiptItemX in existingReceiptItemXs) {
        bool promoExist = false;
        existingReceiptItemX.promos = existingReceiptItemX.promos.map((e) {
          if (e.promoId == params.promo.docId) {
            promoExist = true;
            return e
              ..promotionDetails = PromoBuyXGetYDetails(
                applyCount: (e.promotionDetails as PromoBuyXGetYDetails).applyCount + 1,
                quantity: 0,
                sellingPrice: 0,
                isY: false,
              );
          }
          return e;
        }).toList();

        if (!promoExist) {
          existingReceiptItemX.promos.add(params.promo
            ..promotionDetails = PromoBuyXGetYDetails(applyCount: 1, quantity: 0, isY: false, sellingPrice: 0));
        }
      }

      // Handle Y
      final List<ReceiptItemEntity> receiptItemYs = [];
      for (final conditionAndItemY in params.conditionAndItemYs) {
        final double sellingPrice = conditionAndItemY.itemEntity.includeTax == 0
            ? conditionAndItemY.promoBuyXGetYGetConditionEntity.sellingPrice
            : conditionAndItemY.promoBuyXGetYGetConditionEntity.sellingPrice *
                (100 / (100 + conditionAndItemY.itemEntity.taxRate));

        final existingReceiptItemY =
            existingReceiptItemYs.where((e) => e.itemEntity.barcode == conditionAndItemY.itemEntity.barcode);

        if (existingReceiptItemY.isEmpty) {
          final double discAmount = (conditionAndItemY.itemEntity.dpp - sellingPrice) *
              conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity *
              conditionAndItemY.multiply;
          receiptItemYs.add(
            ReceiptHelper.updateReceiptItemAggregateFields(ReceiptHelper.convertItemEntityToReceiptItemEntity(
                conditionAndItemY.itemEntity,
                conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity * conditionAndItemY.multiply)
              ..discAmount = discAmount
              ..discPrctg = 0
              ..promos = [
                params.promo.copyWith(
                    promotionDetails: PromoBuyXGetYDetails(
                        applyCount: 1,
                        isY: true,
                        sellingPrice: sellingPrice,
                        quantity:
                            conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity * conditionAndItemY.multiply),
                    discAmount: discAmount)
              ]),
          );
        } else {
          final double thisDiscAmount = existingReceiptItemY.first.discAmount == null
              ? (existingReceiptItemY.first.itemEntity.dpp - sellingPrice) *
                  conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity *
                  conditionAndItemY.multiply
              : ((existingReceiptItemY.first.itemEntity.dpp - sellingPrice) *
                  conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity *
                  conditionAndItemY.multiply);
          final double discAmount = existingReceiptItemY.first.discAmount == null
              ? (existingReceiptItemY.first.itemEntity.dpp - sellingPrice) *
                  conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity *
                  conditionAndItemY.multiply
              : existingReceiptItemY.first.discAmount! +
                  ((existingReceiptItemY.first.itemEntity.dpp - sellingPrice) *
                      conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity *
                      conditionAndItemY.multiply);

          List<PromotionsEntity> finalPromos = [];
          if (existingReceiptItemY.first.promos.where((element) => element.promoId == params.promo.promoId).isEmpty) {
            finalPromos = [
              ...existingReceiptItemY.first.promos,
              params.promo.copyWith(
                  discAmount: thisDiscAmount,
                  promotionDetails: PromoBuyXGetYDetails(
                      applyCount: 1,
                      isY: true,
                      sellingPrice: sellingPrice,
                      quantity:
                          conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity * conditionAndItemY.multiply))
            ];
          } else {
            finalPromos = existingReceiptItemY.first.promos.map((e) {
              if (e.promoId == params.promo.promoId && ((e.promotionDetails as PromoBuyXGetYDetails?)?.isY ?? false)) {
                return e.copyWith(
                    discAmount: thisDiscAmount,
                    promotionDetails: ((e.promotionDetails as PromoBuyXGetYDetails)
                      ..isY = true
                      ..applyCount += 1
                      ..quantity +=
                          conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity * conditionAndItemY.multiply));
              }

              return e;
            }).toList();
          }

          // log("finalPromos $finalPromos");

          receiptItemYs.add(
            ReceiptHelper.updateReceiptItemAggregateFields(existingReceiptItemY.first.copyWith(
              quantity: existingReceiptItemY.first.quantity +
                  (conditionAndItemY.promoBuyXGetYGetConditionEntity.quantity * conditionAndItemY.multiply),
              discAmount: discAmount,
              promos: finalPromos,
            )),
          );
        }
      }

      List<ReceiptItemEntity> intersectionReceiptItemXs = existingReceiptItemXs
          .where((element) => itemYBarcodes.contains(element.itemEntity.barcode))
          .map((e) => e.copyWith())
          .toList();
      List<ReceiptItemEntity> exclusiveReceiptItemXs = existingReceiptItemXs
          .where((element) => !itemYBarcodes.contains(element.itemEntity.barcode))
          .map((e) => e.copyWith())
          .toList();
      List<ReceiptItemEntity> exclusiveReceiptItemYs = receiptItemYs
          .where((element) => !itemXBarcodes.contains(element.itemEntity.barcode))
          .map((e) => e.copyWith())
          .toList();

      List<ReceiptItemEntity> finalIntersections = [];
      if (intersectionReceiptItemXs.isNotEmpty) {
        // final List<String> intersectionBarcodes = intersectionReceiptItemXs.map((e) => e.itemEntity.barcode).toList();
        for (ReceiptItemEntity intersectionX in intersectionReceiptItemXs) {
          final ReceiptItemEntity? intersectionY = receiptItemYs
              .where((element) => element.itemEntity.barcode == intersectionX.itemEntity.barcode)
              .firstOrNull;
          if (intersectionY == null) throw "Issue in calculating Buy X Get Y Promotion";
          // log("intersectionY promos ${intersectionY.promos}");
          finalIntersections.add(ReceiptHelper.updateReceiptItemAggregateFields(intersectionX.copyWith(
            quantity: intersectionY.quantity,
            discAmount: intersectionY.discAmount ?? 0,
            promos: intersectionX.promos.where((element) => element.promoId == params.promo.promoId).toList() +
                intersectionY.promos,
          )));
        }
      }

      return params.receiptEntity.copyWith(
        receiptItems: [
          ...otherReceiptItems,
          ...exclusiveReceiptItemXs,
          ...finalIntersections,
          ...exclusiveReceiptItemYs
        ],
        promos: params.receiptEntity.promos.map((e) => e.promoId).contains(params.promo.promoId)
            ? params.receiptEntity.promos.map((e) {
                if (e.promoId == params.promo.promoId) {
                  return e..promotionDetails = ((e.promotionDetails as PromoBuyXGetYDetails)..applyCount += 1);
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
