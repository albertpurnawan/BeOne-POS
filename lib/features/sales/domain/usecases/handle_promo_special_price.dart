import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class HandlePromoSpecialPriceUseCase
    implements UseCase<ReceiptEntity, HandlePromosUseCaseParams> {
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

      List<ReceiptItemEntity> newReceiptItems = [];
      List<PromotionsEntity> promotionsApplied = [];
      double subtotal = 0;
      double taxAmount = 0;
      bool isNewReceiptItem = true;
      final now = DateTime.now();
      final promo = params.promo!;
      final itemEntity = params.receiptItemEntity.itemEntity;
      final quantity = params.receiptItemEntity.quantity;

      // Recreate receipt
      for (var currentReceiptItem in params.receiptEntity.receiptItems) {
        // Handle item exist
        if (currentReceiptItem.itemEntity.barcode ==
            params.receiptItemEntity.itemEntity.barcode) {
          currentReceiptItem.quantity += params.receiptItemEntity.quantity;

          // check promo
          final startHour = promo.startTime.hour;
          final startMinute = promo.startTime.minute;
          final startSecond = promo.startTime.second;
          DateTime startPromo = DateTime(now.year, now.month, now.day,
              startHour, startMinute, startSecond);
          final endHour = promo.endTime.hour;
          final endMinute = promo.endTime.minute;
          final endSecond = promo.endTime.second;
          DateTime endPromo = DateTime(
              now.year, now.month, now.day, endHour, endMinute, endSecond);

          final topsb = await GetIt.instance<AppDatabase>()
              .promoHargaSpesialHeaderDao
              .readByDocId(promo.promoId!, null);
          final tpsb1 = await GetIt.instance<AppDatabase>()
              .promoHargaSpesialBuyDao
              .readByTopsbId(promo.promoId!, null);
          final tpsb1s = await GetIt.instance<AppDatabase>()
              .promoHargaSpesialBuyDao
              .readAllByTopsbId(promo.promoId!, null);

          bool promoAlreadyApplied =
              currentReceiptItem.promos.contains(params.promo);
          double discount = itemEntity.dpp - tpsb1.price;
          double discountBeforeTax = 0;

          // check the time of promo
          if (now.millisecondsSinceEpoch >= startPromo.millisecondsSinceEpoch &&
              now.millisecondsSinceEpoch <= endPromo.millisecondsSinceEpoch) {
            // check promo already applied
            log("promo - $promoAlreadyApplied");
            if (!promoAlreadyApplied) {
              // check promo buy condition: quantity
              if (currentReceiptItem.quantity >= tpsb1.qty) {
                log("Item Fulfilled Conditions");

                if (topsb!.promoAlias == 1) {
                  for (final el in tpsb1s) {
                    if (currentReceiptItem.quantity >= el.qty) {
                      discount =
                          (currentReceiptItem.quantity * itemEntity.price) -
                              ((el.price * el.qty) +
                                  (itemEntity.price *
                                      (currentReceiptItem.quantity - el.qty)));
                      discountBeforeTax = itemEntity.includeTax == 1
                          ? (discount * (100 / (100 + itemEntity.taxRate)))
                          : discount;
                    }
                  }
                } else {
                  if (currentReceiptItem.quantity <=
                      topsb.maxPurchaseTransaction) {
                    int fullSets = (currentReceiptItem.quantity ~/ tpsb1.qty);
                    double remainderItems =
                        (currentReceiptItem.quantity % tpsb1.qty);
                    double expectedSubtotal =
                        (fullSets * tpsb1.price * tpsb1.qty) +
                            (remainderItems * itemEntity.price);
                    double actualTotalPrice =
                        itemEntity.price * currentReceiptItem.quantity;
                    discount = actualTotalPrice - expectedSubtotal;
                    discountBeforeTax = itemEntity.includeTax == 1
                        ? (discount * (100 / (100 + itemEntity.taxRate)))
                        : discount;
                  } else if (currentReceiptItem.quantity >
                      (topsb.maxPurchaseTransaction / tpsb1.qty)) {
                    discount *= topsb.maxPurchaseTransaction;
                  } else {
                    discount = 0;
                  }
                }

                final double priceQty = currentReceiptItem.itemEntity.price *
                    currentReceiptItem.quantity;
                currentReceiptItem.totalSellBarcode = priceQty;
                currentReceiptItem.totalGross =
                    currentReceiptItem.itemEntity.includeTax == 1
                        ? (priceQty *
                            (100 /
                                (100 + currentReceiptItem.itemEntity.taxRate)))
                        : priceQty;
                currentReceiptItem.taxAmount =
                    (currentReceiptItem.totalGross - discountBeforeTax) *
                        (currentReceiptItem.itemEntity.taxRate / 100);

                currentReceiptItem.totalAmount = currentReceiptItem.totalGross +
                    currentReceiptItem.taxAmount;
                isNewReceiptItem = false;

                newReceiptItems.add(ReceiptItemEntity(
                  quantity: currentReceiptItem.quantity,
                  totalGross: currentReceiptItem.totalGross,
                  itemEntity: currentReceiptItem.itemEntity,
                  taxAmount: currentReceiptItem.taxAmount,
                  sellingPrice: currentReceiptItem.sellingPrice,
                  totalAmount: currentReceiptItem.totalAmount,
                  totalSellBarcode: currentReceiptItem.totalSellBarcode,
                  promos: [promo],
                  discAmount: discountBeforeTax,
                ));

                subtotal += currentReceiptItem.totalGross;
                taxAmount += currentReceiptItem.taxAmount;
              } else {
                log("Promo Not Apllied, Conditions Not Met");
                final double priceQty = currentReceiptItem.itemEntity.price *
                    currentReceiptItem.quantity;
                currentReceiptItem.totalSellBarcode = priceQty;
                currentReceiptItem.totalGross =
                    currentReceiptItem.itemEntity.includeTax == 1
                        ? (priceQty *
                            (100 /
                                (100 + currentReceiptItem.itemEntity.taxRate)))
                        : priceQty;
                currentReceiptItem.taxAmount =
                    currentReceiptItem.itemEntity.includeTax == 1
                        ? (priceQty) - currentReceiptItem.totalGross
                        : priceQty *
                            (currentReceiptItem.itemEntity.taxRate / 100);
                currentReceiptItem.totalAmount = currentReceiptItem.totalGross +
                    currentReceiptItem.taxAmount;
                isNewReceiptItem = false;
                newReceiptItems.add(currentReceiptItem);

                subtotal += currentReceiptItem.totalGross;
                taxAmount += currentReceiptItem.taxAmount;
              }
            } else {
              log("Promo Apllied");
              if (topsb!.promoAlias == 1) {
                for (final el in tpsb1s) {
                  if (currentReceiptItem.quantity >= el.qty) {
                    discount =
                        (currentReceiptItem.quantity * itemEntity.price) -
                            ((el.price * el.qty) +
                                (itemEntity.price *
                                    (currentReceiptItem.quantity - el.qty)));
                    discountBeforeTax = itemEntity.includeTax == 1
                        ? (discount * (100 / (100 + itemEntity.taxRate)))
                        : discount;
                  }
                }
              } else {
                if (currentReceiptItem.quantity <=
                    topsb.maxPurchaseTransaction) {
                  int fullSets = (currentReceiptItem.quantity ~/ tpsb1.qty);
                  double remainderItems =
                      (currentReceiptItem.quantity % tpsb1.qty);
                  double expectedSubtotal =
                      (fullSets * tpsb1.price * tpsb1.qty) +
                          (remainderItems * itemEntity.price);
                  double actualTotalPrice =
                      itemEntity.price * currentReceiptItem.quantity;
                  discount = actualTotalPrice - expectedSubtotal;
                  discountBeforeTax = itemEntity.includeTax == 1
                      ? (discount * (100 / (100 + itemEntity.taxRate)))
                      : discount;
                } else if (currentReceiptItem.quantity >
                    (topsb.maxPurchaseTransaction / tpsb1.qty)) {
                  discount *= topsb.maxPurchaseTransaction;
                } else {
                  discount = 0;
                }
              }

              final double priceQty = currentReceiptItem.itemEntity.price *
                  currentReceiptItem.quantity;
              currentReceiptItem.totalSellBarcode = priceQty;
              currentReceiptItem.totalGross =
                  currentReceiptItem.itemEntity.includeTax == 1
                      ? (priceQty *
                          (100 / (100 + currentReceiptItem.itemEntity.taxRate)))
                      : priceQty;
              currentReceiptItem.taxAmount =
                  (currentReceiptItem.totalGross - discountBeforeTax) *
                      (currentReceiptItem.itemEntity.taxRate / 100);

              currentReceiptItem.totalAmount =
                  currentReceiptItem.totalGross + currentReceiptItem.taxAmount;
              isNewReceiptItem = false;

              newReceiptItems.add(ReceiptItemEntity(
                quantity: currentReceiptItem.quantity,
                totalGross: currentReceiptItem.totalGross,
                itemEntity: currentReceiptItem.itemEntity,
                taxAmount: currentReceiptItem.taxAmount,
                sellingPrice: currentReceiptItem.sellingPrice,
                totalAmount: currentReceiptItem.totalAmount,
                totalSellBarcode: currentReceiptItem.totalSellBarcode,
                promos: [promo],
                discAmount: discountBeforeTax,
              ));

              subtotal += currentReceiptItem.totalGross;
              taxAmount += currentReceiptItem.taxAmount;
            }
          } else {
            log("Time Not Fulfilled");
          }
        } else {
          newReceiptItems.add(currentReceiptItem);
          subtotal += currentReceiptItem.totalGross;
          taxAmount += currentReceiptItem.taxAmount;
        }
      }

      // Handle item not exist
      if (isNewReceiptItem) {
        log("NEW ITEM");
        ItemEntity? itemWithPromo = itemEntity.copyWith();

        final topsb = await GetIt.instance<AppDatabase>()
            .promoHargaSpesialHeaderDao
            .readByDocId(promo.promoId!, null);
        final tpsb1 = await GetIt.instance<AppDatabase>()
            .promoHargaSpesialBuyDao
            .readByTopsbId(promo.promoId!, null);
        final tpsb1s = await GetIt.instance<AppDatabase>()
            .promoHargaSpesialBuyDao
            .readAllByTopsbId(promo.promoId!, null);

        double discount = itemEntity.dpp - tpsb1.price;
        ;
        double discountBeforeTax = 0;

        final startHour = promo.startTime.hour;
        final startMinute = promo.startTime.minute;
        final startSecond = promo.startTime.second;
        DateTime startPromo = DateTime(
            now.year, now.month, now.day, startHour, startMinute, startSecond);
        final endHour = promo.endTime.hour;
        final endMinute = promo.endTime.minute;
        final endSecond = promo.endTime.second;
        DateTime endPromo = DateTime(
            now.year, now.month, now.day, endHour, endMinute, endSecond);

        // check the time of promo
        if (now.millisecondsSinceEpoch >= startPromo.millisecondsSinceEpoch &&
            now.millisecondsSinceEpoch <= endPromo.millisecondsSinceEpoch) {
          if (quantity >= tpsb1.qty) {
            // Apply promo directly to itemWithPromo
            itemWithPromo = itemEntity.copyWith(
              price: itemEntity.includeTax == 1
                  ? (itemEntity.dpp) * ((100 + itemEntity.taxRate) / 100)
                  : (itemEntity.price),
              dpp: itemEntity.dpp,
            );
            // Calculate totals
            log("New Receipt With Promo");
            if (topsb!.promoAlias == 1) {
              for (final el in tpsb1s) {
                if (quantity >= el.qty) {
                  discount = (quantity * itemEntity.price) -
                      ((el.price * el.qty) +
                          (itemEntity.price * (quantity - el.qty)));
                  discountBeforeTax = itemEntity.includeTax == 1
                      ? (discount * (100 / (100 + itemEntity.taxRate)))
                      : discount;
                }
              }
            } else {
              if (quantity <= topsb.maxPurchaseTransaction) {
                int fullSets = (quantity ~/ tpsb1.qty);
                double remainderItems = (quantity % tpsb1.qty);
                double expectedSubtotal = (fullSets * tpsb1.price * tpsb1.qty) +
                    (remainderItems * itemEntity.price);
                double actualTotalPrice = itemEntity.price * quantity;
                discount = actualTotalPrice - expectedSubtotal;
                discountBeforeTax = itemEntity.includeTax == 1
                    ? (discount * (100 / (100 + itemEntity.taxRate)))
                    : discount;
              } else if (quantity >
                  (topsb.maxPurchaseTransaction / tpsb1.qty)) {
                discount *= topsb.maxPurchaseTransaction;
              } else {
                discount = 0;
              }
            }

            final double priceQty = itemEntity.price * quantity;
            final double totalSellBarcode = priceQty;
            final double totalGross = itemEntity.includeTax == 1
                ? (priceQty * (100 / (100 + itemEntity.taxRate)))
                : priceQty;
            final double taxAmountNewItem =
                (totalGross - discountBeforeTax) * (itemEntity.taxRate / 100);

            final double totalAmount = totalGross + taxAmountNewItem;

            // Create ReceiptItemEntity and add it to newReceiptItems
            newReceiptItems.add(ReceiptItemEntity(
              quantity: quantity,
              totalGross: totalGross,
              itemEntity: itemWithPromo,
              taxAmount: taxAmountNewItem,
              sellingPrice: itemWithPromo.price,
              totalAmount: totalAmount,
              totalSellBarcode: totalSellBarcode,
              promos: [promo],
              discAmount: discountBeforeTax,
            ));

            promotionsApplied.add(promo);
            subtotal += totalGross;
            taxAmount += taxAmountNewItem;
          } else {
            // Calculate totals
            log("New Receipt With Promo Not Applied");
            final double priceQty = itemEntity.price * quantity;
            final double totalSellBarcode = priceQty;
            final double totalGross = itemEntity.includeTax == 1
                ? (priceQty * (100 / (100 + itemEntity.taxRate)))
                : priceQty;
            final double taxAmountNewItem = itemEntity.includeTax == 1
                ? (priceQty) - totalGross
                : priceQty * (itemEntity.taxRate / 100);
            final double totalAmount = totalGross + taxAmountNewItem;

            // Create ReceiptItemEntity and add it to newReceiptItems
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

            subtotal += totalGross;
            taxAmount += taxAmountNewItem;
          }
        }
      }

      return params.receiptEntity.copyWith(
          receiptItems: newReceiptItems,
          subtotal: subtotal,
          taxAmount: taxAmount,
          grandTotal: subtotal + taxAmount,
          discHeaderPromo: newReceiptItems
              .map((e) => e.discAmount ?? 0)
              .reduce((value, element) => value + element));
    } catch (e) {
      rethrow;
    }
  }
}
