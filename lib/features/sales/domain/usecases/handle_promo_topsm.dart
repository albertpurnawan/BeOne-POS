import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/data/models/promo_spesial_multi_item_detail.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class HandlePromoSpesialMultiItemUseCase implements UseCase<ReceiptEntity, HandlePromosUseCaseParams> {
  HandlePromoSpesialMultiItemUseCase();

  @override
  Future<ReceiptEntity> call({HandlePromosUseCaseParams? params}) async {
    try {
      if (params == null) throw "HandlePromoSpesialMultiItemUseCase requires params";
      if (params.promo == null) throw "Promotion entity required";
      if (params.receiptItemEntity == null) throw "Receipt item entity required";

      List<ReceiptItemEntity> newReceiptItems = [];
      final promo = params.promo;
      final receiptEntity = params.receiptEntity;
      final receiptItemEntity = params.receiptItemEntity;

      if (promo == null) throw "No Promo Spesial Multi Item found";
      if (receiptItemEntity == null) throw "Receipt Item Entity not found";
      final itemEntity = receiptItemEntity.itemEntity;
      final quantity = receiptItemEntity.quantity;

      final topsm =
          await GetIt.instance<AppDatabase>().promoSpesialMultiItemHeaderDao.readByDocId(promo.promoId ?? "", null);
      List<PromoSpesialMultiItemDetailModel> tpsm1s = await GetIt.instance<AppDatabase>()
          .promoSpesialMultiItemDetailDao
          .readAllByTopsmId(promo.promoId ?? "", null);

      if (topsm == null) throw "Invalid 'Promo Special Multi Item' data [ERR:HPSR01]";

      if (topsm.condition == 0) {
        tpsm1s = tpsm1s.where((tpsm1) => tpsm1.toitmId == itemEntity.toitmId).toList();
        if (tpsm1s.first.qtyFrom > tpsm1s.first.qtyTo) {
          throw "Invalid 'Promo Special Multi Item: Check QtyFrom bigger than QtyTo' data [ERR:HPSR02]";
        }
        for (ReceiptItemEntity receiptItem in receiptEntity.receiptItems) {
          if (receiptItem.itemEntity.toitmId == tpsm1s.first.toitmId) {
            double discount = 0;
            double discountBeforeTax = 0;
            if (quantity >= tpsm1s.first.qtyFrom && quantity <= tpsm1s.first.qtyTo) {
              discount = (quantity * itemEntity.price) - (tpsm1s.first.price * quantity);
              discountBeforeTax =
                  itemEntity.includeTax == 1 ? (discount * (100 / (100 + itemEntity.taxRate))) : discount;
            } else if (quantity > tpsm1s.first.qtyTo) {
              int fullSets = (tpsm1s.first.qtyTo ~/ 1);
              double remainderItems = (tpsm1s.first.qtyTo - ((tpsm1s.first.qtyTo / 1).floor() * 1));
              double expectedSubtotal = (fullSets * tpsm1s.first.price * 1) + (remainderItems * itemEntity.price);
              double actualTotalPrice = itemEntity.price * tpsm1s.first.qtyTo;
              discount = actualTotalPrice - expectedSubtotal;
              discountBeforeTax =
                  itemEntity.includeTax == 1 ? (discount * (100 / (100 + itemEntity.taxRate))) : discount;
            } else {
              discount = 0;
              discountBeforeTax = 0;
            }

            final double priceQty = receiptItem.itemEntity.price * receiptItem.quantity;
            receiptItem.totalSellBarcode = priceQty;
            receiptItem.totalGross = receiptItem.itemEntity.includeTax == 1
                ? (priceQty * (100 / (100 + receiptItem.itemEntity.taxRate)))
                : priceQty;
            receiptItem.taxAmount =
                (receiptItem.totalGross - discountBeforeTax) * (receiptItem.itemEntity.taxRate / 100);
            receiptItem.totalAmount = receiptItem.totalGross - discountBeforeTax + receiptItem.taxAmount;

            newReceiptItems.add(ReceiptItemEntity(
              quantity: receiptItem.quantity,
              totalGross: receiptItem.totalGross,
              itemEntity: receiptItem.itemEntity,
              taxAmount: receiptItem.taxAmount,
              sellingPrice: receiptItem.sellingPrice,
              totalAmount: receiptItem.totalAmount,
              totalSellBarcode: receiptItem.totalSellBarcode,
              promos: (discountBeforeTax != 0)
                  ? [promo.copyWith(discAmount: discountBeforeTax)]
                  : [], // change this with ...
              discAmount: discountBeforeTax,
            ));
          } else {
            newReceiptItems.add(receiptItem);
          }
        }
      } else {
        // condition == 0
        bool allItemsExist = tpsm1s.every(
          (promoItem) => receiptEntity.receiptItems.any(
            (receiptItem) => receiptItem.itemEntity.toitmId == promoItem.toitmId, // validate qty here
          ),
        );

        if (allItemsExist) {
          log("ALL PROMO ITEMS EXIST - APPLY PROMO");
          for (ReceiptItemEntity receiptItem in receiptEntity.receiptItems) {
            final promoItem = tpsm1s
                    .where(
                      (tpsm1) => tpsm1.toitmId == receiptItem.itemEntity.toitmId,
                    )
                    .isNotEmpty
                ? tpsm1s.firstWhere((tpsm1) => tpsm1.toitmId == receiptItem.itemEntity.toitmId)
                : null;

            if (promoItem != null) {
              double discount = 0;
              double discountBeforeTax = 0;
              if (quantity >= promoItem.qtyFrom && quantity <= promoItem.qtyTo) {
                discount = (quantity * receiptItem.itemEntity.price) - (promoItem.price * quantity);
                discountBeforeTax = receiptItem.itemEntity.includeTax == 1
                    ? (discount * (100 / (100 + receiptItem.itemEntity.taxRate)))
                    : discount;
              } else if (quantity > promoItem.qtyTo) {
                int fullSets = (promoItem.qtyTo ~/ 1);
                double remainderItems = (promoItem.qtyTo - ((promoItem.qtyTo / 1).floor() * 1));
                double expectedSubtotal =
                    (fullSets * promoItem.price * 1) + (remainderItems * receiptItem.itemEntity.price);
                double actualTotalPrice = receiptItem.itemEntity.price * promoItem.qtyTo;
                discount = actualTotalPrice - expectedSubtotal;
                discountBeforeTax = receiptItem.itemEntity.includeTax == 1
                    ? (discount * (100 / (100 + receiptItem.itemEntity.taxRate)))
                    : discount;
              } else {
                discount = 0;
                discountBeforeTax = 0;
              }

              final double priceQty = receiptItem.itemEntity.price * receiptItem.quantity;
              receiptItem.totalSellBarcode = priceQty;
              receiptItem.totalGross = receiptItem.itemEntity.includeTax == 1
                  ? (priceQty * (100 / (100 + receiptItem.itemEntity.taxRate)))
                  : priceQty;
              receiptItem.taxAmount =
                  (receiptItem.totalGross - discountBeforeTax) * (receiptItem.itemEntity.taxRate / 100);
              receiptItem.totalAmount = receiptItem.totalGross - discountBeforeTax + receiptItem.taxAmount;

              newReceiptItems.add(ReceiptItemEntity(
                quantity: receiptItem.quantity,
                totalGross: receiptItem.totalGross,
                itemEntity: receiptItem.itemEntity,
                taxAmount: receiptItem.taxAmount,
                sellingPrice: receiptItem.sellingPrice,
                totalAmount: receiptItem.totalAmount,
                totalSellBarcode: receiptItem.totalSellBarcode,
                promos: (discountBeforeTax != 0)
                    ? [promo.copyWith(discAmount: discountBeforeTax)]
                    : [], // change this with ...
                discAmount: discountBeforeTax,
              ));
            } else {
              newReceiptItems.add(receiptItem);
            }
          }
        } else {
          log("NOT ALL PROMO ITEMS EXIST - PROMO CANNOT BE APPLIED");
          newReceiptItems.addAll(receiptEntity.receiptItems);
        }
      }

      double grandTotalPromo = 0;
      double subtotalPromo = 0;
      double taxAmountPromo = 0;
      double discountBeforeTaxPromo = 0;
      for (var receiptItem in newReceiptItems) {
        grandTotalPromo += receiptItem.totalAmount;
        subtotalPromo += receiptItem.totalGross;
        taxAmountPromo += receiptItem.taxAmount;
        discountBeforeTaxPromo += receiptItem.discAmount ?? 0;
      }
      return params.receiptEntity.copyWith(
        receiptItems: newReceiptItems,
        subtotal: subtotalPromo - discountBeforeTaxPromo,
        taxAmount: taxAmountPromo,
        grandTotal: grandTotalPromo,
      );
    } catch (e) {
      rethrow;
    }
  }
}
