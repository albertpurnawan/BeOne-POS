import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/navigation_helper.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class HandlePromoSpecialPriceUseCase implements UseCase<ReceiptEntity, HandlePromosUseCaseParams> {
  HandlePromoSpecialPriceUseCase();

  @override
  Future<ReceiptEntity> call({HandlePromosUseCaseParams? params}) async {
    try {
      if (params == null) {
        throw "HandlePromoSpecialPriceUseCase requires params";
      }

      if (params.promo == null) {
        throw "Promotion entity required";
      }

      if (params.receiptItemEntity == null) throw "Receipt item entity required";

      List<ReceiptItemEntity> newReceiptItems = [];
      List<PromotionsEntity> promotionsApplied = [];
      bool isNewReceiptItem = true;
      final promo = params.promo!;
      final itemEntity = params.receiptItemEntity!.itemEntity;
      final quantity = params.receiptItemEntity!.quantity;

      final topsb = await GetIt.instance<AppDatabase>().promoHargaSpesialHeaderDao.readByDocId(promo.promoId!, null);
      final tpsb1 = await GetIt.instance<AppDatabase>().promoHargaSpesialBuyDao.readByTopsbId(promo.promoId!, null);
      final tpsb1s = await GetIt.instance<AppDatabase>().promoHargaSpesialBuyDao.readAllByTopsbId(promo.promoId!, null);

      if (topsb == null) throw "Invalid 'Promo Harga Special' data [ERR:HPSR01]";
      log("check berkelipatan ${topsb.detailQtyValidation == 0 && topsb.promoAlias == 1}");
      if (topsb.detailQtyValidation == 0 && topsb.promoAlias == 1) {
        throw "Invalid 'Promo Harga Special' data [ERR:HPSR02]";
      }
      if (tpsb1.qty != 1 && topsb.detailQtyValidation == 0) {
        throw "Invalid 'Promo Harga Special' data [ERR:HPSR03]";
      }

      final double buyQty = topsb.detailQtyValidation == 1 ? tpsb1.qty : 0.001;

      // Recreate receipt
      for (var currentReceiptItem in params.receiptEntity.receiptItems) {
        // Handle item exist
        if (currentReceiptItem.itemEntity.barcode == params.receiptItemEntity!.itemEntity.barcode) {
          currentReceiptItem.quantity += params.receiptItemEntity!.quantity;

          bool promoAlreadyApplied = currentReceiptItem.promos.contains(params.promo);
          double discount = itemEntity.dpp - tpsb1.price;
          double discountBeforeTax = 0;

          // check promo already applied
          // log("promo - $promoAlreadyApplied");
          if (!promoAlreadyApplied) {
            // check promo buy condition: quantity
            if (currentReceiptItem.quantity >= buyQty) {
              // log("Item Fulfilled Conditions");

              if (topsb.promoAlias == 1) {
                for (final el in tpsb1s) {
                  if (currentReceiptItem.quantity >= el.qty) {
                    discount = (currentReceiptItem.quantity * itemEntity.price) -
                        ((el.price * el.qty) + (itemEntity.price * (currentReceiptItem.quantity - el.qty)));
                    discountBeforeTax =
                        itemEntity.includeTax == 1 ? (discount * (100 / (100 + itemEntity.taxRate))) : discount;
                  }
                }
              } else {
                final double buyQty = topsb.detailQtyValidation == 1 ? tpsb1.qty : 0.001;
                if (currentReceiptItem.quantity <= topsb.maxPurchaseTransaction) {
                  int fullSets = (currentReceiptItem.quantity ~/ buyQty);
                  double remainderItems =
                      (currentReceiptItem.quantity - ((currentReceiptItem.quantity / buyQty).floor() * buyQty));
                  double expectedSubtotal = (fullSets * tpsb1.price * buyQty) + (remainderItems * itemEntity.price);
                  double actualTotalPrice = itemEntity.price * currentReceiptItem.quantity;
                  discount = actualTotalPrice - expectedSubtotal;
                  discountBeforeTax =
                      itemEntity.includeTax == 1 ? (discount * (100 / (100 + itemEntity.taxRate))) : discount;
                } else if (currentReceiptItem.quantity > topsb.maxPurchaseTransaction) {
                  int fullSets = (topsb.maxPurchaseTransaction ~/ buyQty);
                  double remainderItems =
                      (topsb.maxPurchaseTransaction - ((topsb.maxPurchaseTransaction / buyQty).floor() * buyQty));
                  double expectedSubtotal = (fullSets * tpsb1.price * buyQty) + (remainderItems * itemEntity.price);
                  double actualTotalPrice = itemEntity.price * topsb.maxPurchaseTransaction;
                  discount = actualTotalPrice - expectedSubtotal;
                  discountBeforeTax =
                      itemEntity.includeTax == 1 ? (discount * (100 / (100 + itemEntity.taxRate))) : discount;
                } else {
                  discount = 0;
                }
              }

              final double priceQty = currentReceiptItem.itemEntity.price * currentReceiptItem.quantity;
              currentReceiptItem.totalSellBarcode = priceQty;
              currentReceiptItem.totalGross = currentReceiptItem.itemEntity.includeTax == 1
                  ? (priceQty * (100 / (100 + currentReceiptItem.itemEntity.taxRate)))
                  : priceQty;
              currentReceiptItem.taxAmount =
                  (currentReceiptItem.totalGross - discountBeforeTax) * (currentReceiptItem.itemEntity.taxRate / 100);

              currentReceiptItem.totalAmount =
                  currentReceiptItem.totalGross - discountBeforeTax + currentReceiptItem.taxAmount;
              isNewReceiptItem = false;

              newReceiptItems.add(ReceiptItemEntity(
                quantity: currentReceiptItem.quantity,
                totalGross: currentReceiptItem.totalGross,
                itemEntity: currentReceiptItem.itemEntity,
                taxAmount: currentReceiptItem.taxAmount,
                sellingPrice: currentReceiptItem.sellingPrice,
                totalAmount: currentReceiptItem.totalAmount,
                totalSellBarcode: currentReceiptItem.totalSellBarcode,
                promos: [promo.copyWith(discAmount: discountBeforeTax)],
                discAmount: discountBeforeTax,
              ));
            } else {
              // log("Promo Not Apllied, Conditions Not Met");
              final double priceQty = currentReceiptItem.itemEntity.price * currentReceiptItem.quantity;
              currentReceiptItem.totalSellBarcode = priceQty;
              currentReceiptItem.totalGross = currentReceiptItem.itemEntity.includeTax == 1
                  ? (priceQty * (100 / (100 + currentReceiptItem.itemEntity.taxRate)))
                  : priceQty;
              currentReceiptItem.taxAmount = currentReceiptItem.itemEntity.includeTax == 1
                  ? (priceQty) - currentReceiptItem.totalGross
                  : priceQty * (currentReceiptItem.itemEntity.taxRate / 100);
              currentReceiptItem.totalAmount = currentReceiptItem.totalGross + currentReceiptItem.taxAmount;
              isNewReceiptItem = false;
              newReceiptItems.add(currentReceiptItem);
            }
          } else {
            // log("Promo Apllied");
            if (topsb!.promoAlias == 1) {
              for (final el in tpsb1s) {
                if (currentReceiptItem.quantity >= el.qty) {
                  discount = (currentReceiptItem.quantity * itemEntity.price) -
                      ((el.price * el.qty) + (itemEntity.price * (currentReceiptItem.quantity - el.qty)));
                  discountBeforeTax =
                      itemEntity.includeTax == 1 ? (discount * (100 / (100 + itemEntity.taxRate))) : discount;
                }
              }
            } else {
              final double buyQty = topsb.detailQtyValidation == 1 ? tpsb1.qty : 0.001;

              if (currentReceiptItem.quantity <= topsb.maxPurchaseTransaction) {
                int fullSets = (currentReceiptItem.quantity ~/ buyQty);
                double remainderItems = (currentReceiptItem.quantity % buyQty);
                double expectedSubtotal = (fullSets * tpsb1.price * buyQty) + (remainderItems * itemEntity.price);
                double actualTotalPrice = itemEntity.price * currentReceiptItem.quantity;
                discount = actualTotalPrice - expectedSubtotal;
                discountBeforeTax =
                    itemEntity.includeTax == 1 ? (discount * (100 / (100 + itemEntity.taxRate))) : discount;
              } else if (currentReceiptItem.quantity > topsb.maxPurchaseTransaction) {
                int fullSets = (topsb.maxPurchaseTransaction ~/ buyQty);
                double remainderItems = (topsb.maxPurchaseTransaction % buyQty);
                double expectedSubtotal = (fullSets * tpsb1.price * buyQty) + (remainderItems * itemEntity.price);
                double actualTotalPrice = itemEntity.price * topsb.maxPurchaseTransaction;
                discount = actualTotalPrice - expectedSubtotal;
                discountBeforeTax =
                    itemEntity.includeTax == 1 ? (discount * (100 / (100 + itemEntity.taxRate))) : discount;
              } else {
                discount = 0;
              }
            }

            final double priceQty = currentReceiptItem.itemEntity.price * currentReceiptItem.quantity;
            currentReceiptItem.totalSellBarcode = priceQty;
            currentReceiptItem.totalGross = currentReceiptItem.itemEntity.includeTax == 1
                ? (priceQty * (100 / (100 + currentReceiptItem.itemEntity.taxRate)))
                : priceQty;
            currentReceiptItem.taxAmount =
                (currentReceiptItem.totalGross - discountBeforeTax) * (currentReceiptItem.itemEntity.taxRate / 100);

            currentReceiptItem.totalAmount =
                currentReceiptItem.totalGross - discountBeforeTax + currentReceiptItem.taxAmount;
            isNewReceiptItem = false;

            newReceiptItems.add(ReceiptItemEntity(
              quantity: currentReceiptItem.quantity,
              totalGross: currentReceiptItem.totalGross,
              itemEntity: currentReceiptItem.itemEntity,
              taxAmount: currentReceiptItem.taxAmount,
              sellingPrice: currentReceiptItem.sellingPrice,
              totalAmount: currentReceiptItem.totalAmount,
              totalSellBarcode: currentReceiptItem.totalSellBarcode,
              promos: [promo.copyWith(discAmount: discountBeforeTax)],
              discAmount: discountBeforeTax,
            ));
          }
        } else {
          newReceiptItems.add(currentReceiptItem);
        }
      }

      // Handle item not exist
      if (isNewReceiptItem) {
        // log("NEW ITEM");
        ItemEntity? itemWithPromo = itemEntity.copyWith();
        double discount = itemEntity.dpp - tpsb1.price;
        double discountBeforeTax = 0;

        // check the time of promo
        if (quantity >= buyQty) {
          // Apply promo directly to itemWithPromo
          itemWithPromo = itemEntity.copyWith(
            price:
                itemEntity.includeTax == 1 ? (itemEntity.dpp) * ((100 + itemEntity.taxRate) / 100) : (itemEntity.price),
            dpp: itemEntity.dpp,
          );
          // Calculate totals
          // log("New Receipt With Promo");
          if (topsb.promoAlias == 1) {
            for (final el in tpsb1s) {
              if (quantity >= el.qty) {
                discount =
                    (quantity * itemEntity.price) - ((el.price * el.qty) + (itemEntity.price * (quantity - el.qty)));
                discountBeforeTax =
                    itemEntity.includeTax == 1 ? (discount * (100 / (100 + itemEntity.taxRate))) : discount;
              }
            }
          } else {
            final double buyQty = topsb.detailQtyValidation == 1 ? tpsb1.qty : 0.001;
            if (quantity <= topsb.maxPurchaseTransaction) {
              int fullSets = (quantity ~/ buyQty);
              double remainderItems = (quantity - ((quantity / buyQty).floor() * buyQty));
              double expectedSubtotal = (fullSets * tpsb1.price * buyQty) + (remainderItems * itemEntity.price);
              double actualTotalPrice = itemEntity.price * quantity;
              discount = actualTotalPrice - expectedSubtotal;
              discountBeforeTax =
                  itemEntity.includeTax == 1 ? (discount * (100 / (100 + itemEntity.taxRate))) : discount;
            } else if (quantity > topsb.maxPurchaseTransaction) {
              int fullSets = (topsb.maxPurchaseTransaction ~/ buyQty);
              double remainderItems =
                  (topsb.maxPurchaseTransaction - ((topsb.maxPurchaseTransaction / buyQty).floor() * buyQty));
              double expectedSubtotal = (fullSets * tpsb1.price * buyQty) + (remainderItems * itemEntity.price);
              double actualTotalPrice = itemEntity.price * topsb.maxPurchaseTransaction;
              discount = actualTotalPrice - expectedSubtotal;
              discountBeforeTax =
                  itemEntity.includeTax == 1 ? (discount * (100 / (100 + itemEntity.taxRate))) : discount;
            } else {
              discount = 0;
            }
          }

          final double priceQty = itemEntity.price * quantity;
          final double totalSellBarcode = priceQty;
          final double totalGross =
              itemEntity.includeTax == 1 ? (priceQty * (100 / (100 + itemEntity.taxRate))) : priceQty;
          final double taxAmountNewItem = (totalGross - discountBeforeTax) * (itemEntity.taxRate / 100);

          final double totalAmount = totalGross - discountBeforeTax + taxAmountNewItem;

          newReceiptItems.add(ReceiptItemEntity(
            quantity: quantity,
            totalGross: totalGross,
            itemEntity: itemWithPromo,
            taxAmount: taxAmountNewItem,
            sellingPrice: itemWithPromo.price,
            totalAmount: totalAmount,
            totalSellBarcode: totalSellBarcode,
            promos: [promo.copyWith(discAmount: discountBeforeTax)],
            discAmount: discountBeforeTax,
          ));

          promotionsApplied.add(promo);
        } else {
          // Calculate totals
          // log("New Receipt With Promo Not Applied");
          final double priceQty = itemEntity.price * quantity;
          final double totalSellBarcode = priceQty;
          final double totalGross =
              itemEntity.includeTax == 1 ? (priceQty * (100 / (100 + itemEntity.taxRate))) : priceQty;
          final double taxAmountNewItem =
              itemEntity.includeTax == 1 ? (priceQty) - totalGross : priceQty * (itemEntity.taxRate / 100);
          final double totalAmount = totalGross + taxAmountNewItem;

          newReceiptItems.add(ReceiptItemEntity(
            quantity: quantity,
            totalGross: totalGross,
            itemEntity: itemEntity,
            taxAmount: taxAmountNewItem,
            sellingPrice: itemEntity.price,
            totalAmount: totalAmount,
            totalSellBarcode: totalSellBarcode,
            promos: [],
          ));
          promotionsApplied.add(promo);
        }
      }

      return params.receiptEntity.copyWith(
        receiptItems: newReceiptItems,
      );
    } catch (e) {
      rethrow;
    }
  }
}
