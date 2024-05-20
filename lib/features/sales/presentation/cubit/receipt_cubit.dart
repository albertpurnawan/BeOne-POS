// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer' as dev;
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/resources/error_handler.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/invoice_service.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_buy_x_get_y_applicability.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/delete_queued_receipt_by_docId.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_employee.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_by_barcode.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_open_price.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_buy_x_get_y.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_special_price.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_without_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/open_cash_drawer.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/queue_receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_receipt_by_new_receipt_items.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_tax.dart';
import 'package:pos_fe/features/sales/domain/usecases/save_receipt.dart';
import 'package:pos_fe/features/sales/presentation/widgets/open_price_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/promo_get_y_dialog.dart';

part 'receipt_state.dart';

class ReceiptCubit extends Cubit<ReceiptEntity> {
  final GetItemByBarcodeUseCase _getItemByBarcodeUseCase;
  final SaveReceiptUseCase _saveReceiptUseCase;
  final GetEmployeeUseCase _getEmployeeUseCase;
  final PrintReceiptUseCase _printReceiptUsecase;
  final OpenCashDrawerUseCase _openCashDrawerUseCase;
  final QueueReceiptUseCase _queueReceiptUseCase;
  final DeleteQueuedReceiptUseCase _deleteQueuedReceiptUseCase;
  final HandleOpenPriceUseCase _handleOpenPriceUseCase;
  final CheckPromoUseCase _checkPromoUseCase;
  final HandlePromosUseCase _handlePromos;
  final HandleWithoutPromosUseCase _handleWithoutPromosUseCase;
  final RecalculateReceiptUseCase _recalculateReceiptUseCase;
  final CheckBuyXGetYApplicabilityUseCase _checkBuyXGetYApplicabilityUseCase;
  final HandlePromoBuyXGetYUseCase _handlePromoBuyXGetYUseCase;
  final HandlePromoSpecialPriceUseCase _handlePromoSpecialPriceUseCase;
  final RecalculateTaxUseCase _recalculateTaxUseCase;

  ReceiptCubit(
    this._getItemByBarcodeUseCase,
    this._saveReceiptUseCase,
    this._getEmployeeUseCase,
    this._printReceiptUsecase,
    this._openCashDrawerUseCase,
    this._queueReceiptUseCase,
    this._deleteQueuedReceiptUseCase,
    this._handleOpenPriceUseCase,
    this._checkPromoUseCase,
    this._handlePromos,
    this._handleWithoutPromosUseCase,
    this._recalculateReceiptUseCase,
    this._checkBuyXGetYApplicabilityUseCase,
    this._handlePromoBuyXGetYUseCase,
    this._handlePromoSpecialPriceUseCase,
    this._recalculateTaxUseCase,
  ) : super(ReceiptEntity(
            docNum:
                "S0001-${DateFormat('yyMMdd').format(DateTime.now())}${Random().nextInt(999) + 1000}/INV1",
            receiptItems: [],
            subtotal: 0,
            totalTax: 0,
            transStart: DateTime.now(),
            taxAmount: 0,
            grandTotal: 0,
            vouchers: [],
            promos: []));

  void addOrUpdateReceiptItems(String itemBarcode, double quantity) async {
    if (quantity <= 0) {
      // Error
      print("quantity null");
      return;
    }

    if (state.receiptItems.isEmpty) {
      final EmployeeEntity? employeeEntity = await _getEmployeeUseCase.call();
      emit(state.copyWith(employeeEntity: employeeEntity));
    }

    final ItemEntity? itemEntity =
        await _getItemByBarcodeUseCase.call(params: itemBarcode);
    if (itemEntity == null) {
      print("itemEntity null");
      return;
    }

    dev.log("ADD ITEM BY BARCODE");

    List<ReceiptItemEntity> newReceiptItems = [];
    List<PromotionsEntity> promotionsApplied = [];
    double subtotal = 0;
    double taxAmount = 0;
    bool isNewReceiptItem = true;
    final now = DateTime.now();
    final topos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();

    bool promoApplied;

    for (var currentReceiptItem in state.receiptItems) {
      // double itemSubtotal = 0;
      // double itemTaxAmount = 0;

      if (currentReceiptItem.itemEntity.barcode == itemBarcode) {
        currentReceiptItem.quantity += quantity;
        final checkPromoUseCase = GetIt.instance<CheckPromoUseCase>();
        final promos = await checkPromoUseCase.call(params: itemEntity.toitmId);

        // check promo
        if (promos.isNotEmpty) {
          for (final promo in promos) {
            if (promo != null) {
              if (promo.toitmId == itemEntity.toitmId) {
                final startHour = promo.startTime.hour;
                final startMinute = promo.startTime.minute;
                final startSecond = promo.startTime.second;
                DateTime startPromo = DateTime(now.year, now.month, now.day,
                    startHour, startMinute, startSecond);
                final endHour = promo.endTime.hour;
                final endMinute = promo.endTime.minute;
                final endSecond = promo.endTime.second;
                DateTime endPromo = DateTime(now.year, now.month, now.day,
                    endHour, endMinute, endSecond);
                switch (promo.promoType) {
                  case 103:
                    break;
                  case 202:
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
                        currentReceiptItem.promos.contains(promo);
                    double discount = itemEntity.price - tpsb1.price;
                    double discountBeforeTax = 0;

                    // check the time of promo
                    if (now.millisecondsSinceEpoch >=
                            startPromo.millisecondsSinceEpoch &&
                        now.millisecondsSinceEpoch <=
                            endPromo.millisecondsSinceEpoch) {
                      // check promo already applied
                      dev.log("promo - $promoAlreadyApplied");
                      if (!promoAlreadyApplied) {
                        // check promo buy condition: quantity
                        if (currentReceiptItem.quantity >= tpsb1.qty) {
                          dev.log("Item Fulfilled Conditions");

                          if (topsb!.promoAlias == 1) {
                            for (final el in tpsb1s) {
                              if (currentReceiptItem.quantity >= el.qty) {
                                discount = (currentReceiptItem.quantity *
                                        itemEntity.price) -
                                    ((el.price * el.qty) +
                                        (itemEntity.price *
                                            (currentReceiptItem.quantity -
                                                el.qty)));
                                discountBeforeTax = itemEntity.includeTax == 1
                                    ? (discount *
                                        (100 / (100 + itemEntity.taxRate)))
                                    : discount;
                              }
                            }
                          } else {
                            if (currentReceiptItem.quantity <=
                                topsb.maxPurchaseTransaction) {
                              int fullSets =
                                  (currentReceiptItem.quantity ~/ tpsb1.qty);
                              double remainderItems =
                                  (currentReceiptItem.quantity % tpsb1.qty);
                              double expectedSubtotal =
                                  (fullSets * tpsb1.price * tpsb1.qty) +
                                      (remainderItems * itemEntity.price);
                              double actualTotalPrice = itemEntity.price *
                                  currentReceiptItem.quantity;
                              discount = actualTotalPrice - expectedSubtotal;
                              discountBeforeTax = itemEntity.includeTax == 1
                                  ? (discount *
                                      (100 / (100 + itemEntity.taxRate)))
                                  : discount;
                            } else if (currentReceiptItem.quantity >
                                (topsb.maxPurchaseTransaction / tpsb1.qty)) {
                              discount *= topsb.maxPurchaseTransaction;
                            } else {
                              discount = 0;
                            }
                          }

                          final double priceQty =
                              currentReceiptItem.itemEntity.price *
                                  currentReceiptItem.quantity;
                          currentReceiptItem.totalSellBarcode = priceQty;
                          currentReceiptItem.totalGross =
                              currentReceiptItem.itemEntity.includeTax == 1
                                  ? (priceQty *
                                      (100 /
                                          (100 +
                                              currentReceiptItem
                                                  .itemEntity.taxRate)))
                                  : priceQty;
                          currentReceiptItem.taxAmount =
                              (currentReceiptItem.totalGross -
                                      discountBeforeTax) *
                                  (currentReceiptItem.itemEntity.taxRate / 100);

                          currentReceiptItem.totalAmount =
                              currentReceiptItem.totalGross +
                                  currentReceiptItem.taxAmount;
                          isNewReceiptItem = false;

                          newReceiptItems.add(ReceiptItemEntity(
                            quantity: currentReceiptItem.quantity,
                            totalGross: currentReceiptItem.totalGross,
                            itemEntity: currentReceiptItem.itemEntity,
                            taxAmount: currentReceiptItem.taxAmount,
                            sellingPrice: currentReceiptItem.sellingPrice,
                            totalAmount: currentReceiptItem.totalAmount,
                            totalSellBarcode:
                                currentReceiptItem.totalSellBarcode,
                            promos: [promo],
                            discAmount: discount,
                          ));

                          subtotal += currentReceiptItem.totalGross;
                          taxAmount += currentReceiptItem.taxAmount;
                        } else {
                          dev.log("Promo Not Apllied, Conditions Not Met");
                          final double priceQty =
                              tpsb1.price * currentReceiptItem.quantity;
                          currentReceiptItem.totalSellBarcode = priceQty;
                          currentReceiptItem.totalGross =
                              currentReceiptItem.itemEntity.includeTax == 1
                                  ? (priceQty *
                                      (100 /
                                          (100 +
                                              currentReceiptItem
                                                  .itemEntity.taxRate)))
                                  : priceQty;
                          currentReceiptItem.taxAmount =
                              currentReceiptItem.itemEntity.includeTax == 1
                                  ? (priceQty) - currentReceiptItem.totalGross
                                  : priceQty *
                                      (currentReceiptItem.itemEntity.taxRate /
                                          100);
                          currentReceiptItem.totalAmount =
                              currentReceiptItem.totalGross +
                                  currentReceiptItem.taxAmount;
                          isNewReceiptItem = false;
                          newReceiptItems.add(currentReceiptItem);

                          subtotal += currentReceiptItem.totalGross;
                          taxAmount += currentReceiptItem.taxAmount;
                        }
                      } else {
                        dev.log("Promo Apllied");
                        if (topsb!.promoAlias == 1) {
                          for (final el in tpsb1s) {
                            if (currentReceiptItem.quantity >= el.qty) {
                              discount = (currentReceiptItem.quantity *
                                      itemEntity.price) -
                                  ((el.price * el.qty) +
                                      (itemEntity.price *
                                          (currentReceiptItem.quantity -
                                              el.qty)));
                              discountBeforeTax = itemEntity.includeTax == 1
                                  ? (discount *
                                      (100 / (100 + itemEntity.taxRate)))
                                  : discount;
                            }
                          }
                        } else {
                          if (currentReceiptItem.quantity <=
                              topsb.maxPurchaseTransaction) {
                            int fullSets =
                                (currentReceiptItem.quantity ~/ tpsb1.qty);
                            double remainderItems =
                                (currentReceiptItem.quantity % tpsb1.qty);
                            double expectedSubtotal =
                                (fullSets * tpsb1.price * tpsb1.qty) +
                                    (remainderItems * itemEntity.price);
                            double actualTotalPrice =
                                itemEntity.price * currentReceiptItem.quantity;
                            discount = actualTotalPrice - expectedSubtotal;
                            discountBeforeTax = itemEntity.includeTax == 1
                                ? (discount *
                                    (100 / (100 + itemEntity.taxRate)))
                                : discount;
                          } else if (currentReceiptItem.quantity >
                              (topsb.maxPurchaseTransaction / tpsb1.qty)) {
                            discount *= topsb.maxPurchaseTransaction;
                          } else {
                            discount = 0;
                          }
                        }

                        final double priceQty =
                            currentReceiptItem.itemEntity.price *
                                currentReceiptItem.quantity;
                        currentReceiptItem.totalSellBarcode = priceQty;
                        currentReceiptItem.totalGross =
                            currentReceiptItem.itemEntity.includeTax == 1
                                ? (priceQty *
                                    (100 /
                                        (100 +
                                            currentReceiptItem
                                                .itemEntity.taxRate)))
                                : priceQty;
                        currentReceiptItem.taxAmount =
                            (currentReceiptItem.totalGross -
                                    discountBeforeTax) *
                                (currentReceiptItem.itemEntity.taxRate / 100);

                        currentReceiptItem.totalAmount =
                            currentReceiptItem.totalGross +
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
                          discAmount: discount,
                        ));

                        subtotal +=
                            currentReceiptItem.totalGross - discountBeforeTax;
                        taxAmount += currentReceiptItem.taxAmount;
                      }
                    } else {
                      dev.log("Time Not Fulfilled");
                    }
                    break;
                  default:
                    dev.log("UPDATE RECEIPT ITEM DEfAULT");
                    final double priceQty =
                        currentReceiptItem.itemEntity.price *
                            currentReceiptItem.quantity;
                    currentReceiptItem.totalSellBarcode = priceQty;
                    currentReceiptItem.totalGross =
                        currentReceiptItem.itemEntity.includeTax == 1
                            ? (priceQty *
                                (100 /
                                    (100 +
                                        currentReceiptItem.itemEntity.taxRate)))
                            : priceQty;
                    currentReceiptItem.taxAmount =
                        currentReceiptItem.itemEntity.includeTax == 1
                            ? (priceQty) - currentReceiptItem.totalGross
                            : priceQty *
                                (currentReceiptItem.itemEntity.taxRate / 100);
                    currentReceiptItem.totalAmount =
                        currentReceiptItem.totalGross +
                            currentReceiptItem.taxAmount;
                    isNewReceiptItem = false;
                    newReceiptItems.add(currentReceiptItem);

                    subtotal += currentReceiptItem.totalGross;
                    taxAmount += currentReceiptItem.taxAmount;
                    break;
                }
              }
            }
          }
        } else {
          dev.log("UPDATE RECEIPT ITEM DEfAULT");
          final double priceQty =
              currentReceiptItem.itemEntity.price * currentReceiptItem.quantity;
          currentReceiptItem.totalSellBarcode = priceQty;
          currentReceiptItem.totalGross =
              currentReceiptItem.itemEntity.includeTax == 1
                  ? (priceQty *
                      (100 / (100 + currentReceiptItem.itemEntity.taxRate)))
                  : priceQty;
          currentReceiptItem.taxAmount =
              currentReceiptItem.itemEntity.includeTax == 1
                  ? (priceQty) - currentReceiptItem.totalGross
                  : priceQty * (currentReceiptItem.itemEntity.taxRate / 100);
          currentReceiptItem.totalAmount =
              currentReceiptItem.totalGross + currentReceiptItem.taxAmount;
          isNewReceiptItem = false;
          newReceiptItems.add(currentReceiptItem);

          subtotal += currentReceiptItem.totalGross;
          taxAmount += currentReceiptItem.taxAmount;
        }
      } else {
        newReceiptItems.add(currentReceiptItem);
        subtotal += currentReceiptItem.totalGross;
        taxAmount += currentReceiptItem.taxAmount;
      }
      // subtotal += subtotal;
      // taxAmount += taxAmount;
    }

    if (isNewReceiptItem) {
      // Check promo
      dev.log("NEW ITEM");
      final checkPromoUseCase = GetIt.instance<CheckPromoUseCase>();
      final promos = await checkPromoUseCase.call(params: itemEntity.toitmId);
      ItemEntity? itemWithPromo = itemEntity.copyWith();

      if (promos.isNotEmpty) {
        for (final promo in promos) {
          if (promo!.toitmId == itemEntity.toitmId) {
            switch (promo.promoType) {
              case 103:
              case 202:
                final topsb = await GetIt.instance<AppDatabase>()
                    .promoHargaSpesialHeaderDao
                    .readByDocId(promo.promoId!, null);
                final tpsb1 = await GetIt.instance<AppDatabase>()
                    .promoHargaSpesialBuyDao
                    .readByTopsbId(promo.promoId!, null);
                final tpsb1s = await GetIt.instance<AppDatabase>()
                    .promoHargaSpesialBuyDao
                    .readAllByTopsbId(promo.promoId!, null);

                double discount = itemEntity.price - tpsb1.price;
                double discountBeforeTax = 0;

                final startHour = promo.startTime.hour;
                final startMinute = promo.startTime.minute;
                final startSecond = promo.startTime.second;
                DateTime startPromo = DateTime(now.year, now.month, now.day,
                    startHour, startMinute, startSecond);
                final endHour = promo.endTime.hour;
                final endMinute = promo.endTime.minute;
                final endSecond = promo.endTime.second;
                DateTime endPromo = DateTime(now.year, now.month, now.day,
                    endHour, endMinute, endSecond);

                // check the time of promo
                if (now.millisecondsSinceEpoch >=
                        startPromo.millisecondsSinceEpoch &&
                    now.millisecondsSinceEpoch <=
                        endPromo.millisecondsSinceEpoch) {
                  if (quantity >= tpsb1.qty) {
                    // Apply promo directly to itemWithPromo
                    itemWithPromo = itemEntity.copyWith(
                      price: itemEntity.includeTax == 1
                          ? (itemEntity.dpp) *
                              ((100 + itemEntity.taxRate) / 100)
                          : (itemEntity.price),
                      dpp: itemEntity.dpp,
                    );
                    // Calculate totals
                    dev.log("New Receipt With Promo");
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
                        double expectedSubtotal =
                            (fullSets * tpsb1.price * tpsb1.qty) +
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
                        ? (priceQty * (100 / (100 + itemEntity.taxRate))) -
                            discountBeforeTax
                        : priceQty;
                    final double taxAmountNewItem =
                        (totalGross - discountBeforeTax) *
                            (itemEntity.taxRate / 100);

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
                      discAmount: discount,
                    ));

                    promoApplied = true;
                    promotionsApplied.add(promo);
                    subtotal += totalGross;
                    taxAmount += taxAmountNewItem;
                  } else {
                    // Calculate totals
                    dev.log("New Receipt With Promo Not Applied");
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
                break;
              // case 203:
              //   final topdi = await GetIt.instance<AppDatabase>()
              //       .promoDiskonItemHeaderDao
              //       .readByDocId(promo.promoId!, null);
              //   final tpdi1s = await GetIt.instance<AppDatabase>()
              //       .promoDiskonItemBuyConditionDao
              //       .readAllByTopdiId(promo.promoId!, null);
              //   final startHour = promo.startTime.hour;
              //   final startMinute = promo.startTime.minute;
              //   final startSecond = promo.startTime.second;
              //   DateTime startPromo = DateTime(now.year, now.month, now.day,
              //       startHour, startMinute, startSecond);
              //   final endHour = promo.endTime.hour;
              //   final endMinute = promo.endTime.minute;
              //   final endSecond = promo.endTime.second;
              //   DateTime endPromo = DateTime(now.year, now.month, now.day,
              //       endHour, endMinute, endSecond);
              // check the time of promo
              // if (now.millisecondsSinceEpoch >=
              //         startPromo.millisecondsSinceEpoch &&
              //     now.millisecondsSinceEpoch <=
              //         endPromo.millisecondsSinceEpoch) {
              // switch (topdi!.promoType) {
              //   case 1:
              //     if (topdi.buyCondition == 0) {
              //       //do promo condition OR
              //       if (topdi.promoValue != 0) {
              //         //do discount nominal on each item
              //       } else if (topdi.discount1 != 0 ||
              //           topdi.discount2 != 0 ||
              //           topdi.discount3 != 0) {
              //         //do discount percentage on each item
              //       }
              //     } else {
              //       //do promo condition AND
              //       if (topdi.promoValue != 0) {
              //         //do discount nominal on all items
              //       } else if (topdi.discount1 != 0 ||
              //           topdi.discount2 != 0 ||
              //           topdi.discount3 != 0) {
              //         //do discount percentage on all items
              //       }
              //     }
              //     break;
              //   case 2:
              //     if (topdi.buyCondition == 0) {
              //     } else {}
              //     break;
              //   case 3:
              //     if (topdi.buyCondition == 0) {
              //     } else {}
              //     break;
              //   case 4:
              //     if (topdi.buyCondition == 0) {
              //     } else {}
              //     break;
              //   default:
              //     break;
              // }
              // // }
              // break;
              default:
                dev.log("New Receipt With Promo ");
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
                // promotionsApplied.add(promo);

                subtotal += totalGross;
                taxAmount += taxAmountNewItem;
                break;
            }
          }
        }
      } else {
        ///
        // Calculate totals
        dev.log("NEW ITEM NO PROMO");
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
        subtotal += totalGross;
        taxAmount += taxAmountNewItem;
      }
    }
    final ReceiptEntity newState = state.copyWith(
      receiptItems: newReceiptItems,
      subtotal: subtotal,
      taxAmount: taxAmount,
      grandTotal: subtotal + taxAmount,
    );
    emit(newState);
  }

  void addOrUpdateReceiptItemWithOpenPrice(
      ItemEntity itemEntity, double quantity, double? dpp) async {
    if (quantity <= 0) {
      // Error
      print("quantity null");
      return;
    }

    if (state.receiptItems.isEmpty) {
      final EmployeeEntity? employeeEntity = await _getEmployeeUseCase.call();
      emit(state.copyWith(employeeEntity: employeeEntity));
    }

    ItemEntity? priceSetItemEntity;

    if (itemEntity.openPrice == 1 && dpp != null) {
      priceSetItemEntity = itemEntity.copyWith(
          price: itemEntity.includeTax == 1
              ? dpp * ((100 + itemEntity.taxRate) / 100)
              : dpp,
          dpp: dpp);
    } else {
      priceSetItemEntity = itemEntity;
    }

    List<ReceiptItemEntity> newReceiptItems = [];
    double subtotal = 0;
    double taxAmount = 0;
    bool isNewReceiptItem = true;
    List<PromotionsEntity> promotionsApplied = [];
    ReceiptItemEntity? receiptItemEntityAfterPromoCheck;

    for (final currentReceiptItem in state.receiptItems) {
      if (currentReceiptItem.itemEntity.barcode == priceSetItemEntity.barcode &&
          currentReceiptItem.itemEntity.price == priceSetItemEntity.price) {
        currentReceiptItem.quantity += quantity;
        receiptItemEntityAfterPromoCheck = currentReceiptItem;
        // check promo
        final checkPromoUseCase = GetIt.instance<CheckPromoUseCase>();
        final promos = await checkPromoUseCase.call(params: itemEntity.toitmId);

        if (promos.isNotEmpty) {
          for (final promo in promos) {
            if (promo!.toitmId == itemEntity.toitmId) {
              switch (promo.promoType) {
                case 301:
                  bool topsbApplied = currentReceiptItem.promos.contains(promo);

                  if (!topsbApplied) {
                    final tpsb1 = await GetIt.instance<AppDatabase>()
                        .promoHargaSpesialBuyDao
                        .readByTopsbId(promo.promoId!, null);
                    if (currentReceiptItem.quantity >= tpsb1.qty) {
                      receiptItemEntityAfterPromoCheck =
                          currentReceiptItem.copyWith(
                        itemEntity: currentReceiptItem.itemEntity.copyWith(
                          price: itemEntity.includeTax == 1
                              ? (currentReceiptItem.itemEntity.dpp -
                                      tpsb1.price) *
                                  ((100 + itemEntity.taxRate) / 100)
                              : currentReceiptItem.itemEntity.dpp - tpsb1.price,
                          dpp: currentReceiptItem.itemEntity.dpp - tpsb1.price,
                        ),
                        promos: [...currentReceiptItem.promos, promo],
                      );
                      promotionsApplied.add(promo);
                    }
                  }

                  break;
                default:
              }
            }
          }
        }

        final double priceQty =
            receiptItemEntityAfterPromoCheck!.itemEntity.price *
                receiptItemEntityAfterPromoCheck.quantity;
        receiptItemEntityAfterPromoCheck.totalSellBarcode = priceQty;
        receiptItemEntityAfterPromoCheck.totalGross =
            receiptItemEntityAfterPromoCheck.itemEntity.includeTax == 1
                ? (priceQty *
                    (100 /
                        (100 +
                            receiptItemEntityAfterPromoCheck
                                .itemEntity.taxRate)))
                : priceQty;
        receiptItemEntityAfterPromoCheck.taxAmount =
            receiptItemEntityAfterPromoCheck.itemEntity.includeTax == 1
                ? (priceQty) - receiptItemEntityAfterPromoCheck.totalGross
                : priceQty *
                    (receiptItemEntityAfterPromoCheck.itemEntity.taxRate / 100);
        receiptItemEntityAfterPromoCheck.totalAmount =
            receiptItemEntityAfterPromoCheck.totalGross +
                receiptItemEntityAfterPromoCheck.taxAmount;
        isNewReceiptItem = false;
        newReceiptItems.add(receiptItemEntityAfterPromoCheck);
      } else {
        newReceiptItems.add(currentReceiptItem);
      }
      if (receiptItemEntityAfterPromoCheck != null) {
        subtotal += receiptItemEntityAfterPromoCheck.totalGross;
        taxAmount += receiptItemEntityAfterPromoCheck.taxAmount;
      }
    }

    if (isNewReceiptItem) {
      //check promo
      final checkPromoUseCase = GetIt.instance<CheckPromoUseCase>();
      final promos = await checkPromoUseCase.call(params: itemEntity.toitmId);
      ItemEntity? itemWithPromo = itemEntity.copyWith();

      if (promos.isNotEmpty) {
        for (final promo in promos) {
          if (promo!.toitmId == itemEntity.toitmId) {
            switch (promo.promoType) {
              case 301:
                final tpsb1 = await GetIt.instance<AppDatabase>()
                    .promoHargaSpesialBuyDao
                    .readByTopsbId(promo.promoId!, null);

                if (quantity >= tpsb1.qty) {
                  itemWithPromo = itemEntity.copyWith(
                    price: itemEntity.includeTax == 1
                        ? (itemEntity.dpp - tpsb1.price) *
                            ((100 + itemEntity.taxRate) / 100)
                        : (itemEntity.dpp - tpsb1.price),
                    dpp: itemEntity.dpp - tpsb1.price,
                  );
                  promotionsApplied.add(promo);
                }
                final double priceQty = itemWithPromo!.price * quantity;
                final double totalSellBarcode = priceQty;
                final double totalGross = itemWithPromo.includeTax == 1
                    ? (priceQty * (100 / (100 + itemWithPromo.taxRate)))
                    : priceQty;
                final double taxAmountNewItem = itemWithPromo.includeTax == 1
                    ? (priceQty) - totalGross
                    : priceQty * (itemWithPromo.taxRate / 100);
                final double totalAmount = totalGross + taxAmountNewItem;
                newReceiptItems.add(ReceiptItemEntity(
                  quantity: quantity,
                  totalGross: totalGross,
                  itemEntity: itemWithPromo,
                  taxAmount: taxAmountNewItem,
                  sellingPrice: itemWithPromo.price,
                  totalAmount: totalAmount,
                  totalSellBarcode: totalSellBarcode,
                  promos: [promo],
                ));
                subtotal += totalGross;
                taxAmount += taxAmountNewItem;
                break;
              default:
                final double priceQty = itemEntity.price * quantity;
                final double totalSellBarcode = priceQty;
                final double totalGross = itemEntity.includeTax == 1
                    ? (priceQty * (100 / (100 + itemEntity.taxRate)))
                    : priceQty;
                final double taxAmountNewItem = itemEntity.includeTax == 1
                    ? (priceQty) - totalGross
                    : priceQty * (itemEntity.taxRate / 100);
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
                subtotal += totalGross;
                taxAmount += taxAmountNewItem;
            }
          }
        }
      }
    }

    final ReceiptEntity newState = state.copyWith(
      receiptItems: newReceiptItems,
      subtotal: subtotal,
      taxAmount: taxAmount,
      grandTotal: subtotal + taxAmount,
    );
    emit(newState);
  }

  void addOrUpdateReceiptItemsBySearch(ItemEntity itemEntity) async {
    dev.log("ADD ITEM BY SEARCH");

    return addOrUpdateReceiptItems(itemEntity.barcode, 1);
  }

  Future<void> addUpdateReceiptItems(AddUpdateReceiptItemsParams params) async {
    try {
      // Declare variables
      final ItemEntity? itemEntity;
      ReceiptItemEntity receiptItemEntity;
      final List<PromotionsEntity?> availablePromos;
      ReceiptEntity newReceipt = state;

      // Validate params
      if (params.barcode == null && params.itemEntity == null) {
        throw "Item barcode or item required";
      }

      // Get item entity and validate
      if (params.barcode != null) {
        itemEntity =
            await _getItemByBarcodeUseCase.call(params: params.barcode);
      } else {
        itemEntity = params.itemEntity;
      }
      if (itemEntity == null) throw "Item not found";

      // Convert item entity to receipt item entity
      receiptItemEntity = ReceiptHelper.convertItemEntityToReceiptItemEntity(
          itemEntity, params.quantity);

      // Handle open price
      if (receiptItemEntity.itemEntity.openPrice == 1) {
        final List<ReceiptItemEntity> existingItem = newReceipt.receiptItems
            .where((element) =>
                element.itemEntity.barcode ==
                receiptItemEntity.itemEntity.barcode)
            .toList();
        final bool isItemExist = existingItem.isNotEmpty;

        if (isItemExist) {
          receiptItemEntity = ReceiptHelper.updateReceiptItemAggregateFields(
              receiptItemEntity.copyWith(
                  quantity: params.quantity,
                  itemEntity: existingItem[0].itemEntity));
        } else {
          final double? newPrice = await showDialog<double>(
            context: params.context,
            barrierDismissible: false,
            builder: (context) => OpenPriceDialog(
                receiptItemEntity: receiptItemEntity,
                quantity: params.quantity),
          );
          params.onOpenPriceInputted();
          if (newPrice == null) throw "Price is required";
          receiptItemEntity = await _handleOpenPriceUseCase(
              params: HandleOpenPriceUseCaseParams(
                  receiptItemEntity: receiptItemEntity, newPrice: newPrice!));
        }
      }

      // Handle promos
      availablePromos = await _checkPromoUseCase(
          params: receiptItemEntity.itemEntity.toitmId);
      bool anyPromoApplied = false;
      if (availablePromos.isNotEmpty) {
        for (final availablePromo in availablePromos) {
          switch (availablePromo!.promoType) {
            case 103:
              // Check applicability
              final CheckBuyXGetYApplicabilityResult
                  checkBuyXGetYApplicability =
                  await _checkBuyXGetYApplicabilityUseCase.call(
                      params: CheckBuyXGetYApplicabilityParams(
                          receiptEntity: state,
                          receiptItemEntity: receiptItemEntity,
                          promo: availablePromo));

              if (checkBuyXGetYApplicability.isApplicable) {
                continue inApplicable;
              }

              // Check Y conditions
              if (checkBuyXGetYApplicability.toprb!.getCondition == 0) {
              } else {}

            // Show Pop Up
            // Diperlukan receipt before check and receipt after check

            // Handle promo buy X get Y
            case 202:
              newReceipt = await _handlePromoSpecialPriceUseCase.call(
                  params: HandlePromosUseCaseParams(
                receiptItemEntity: receiptItemEntity,
                receiptEntity: newReceipt,
                promo: availablePromo,
              ));
              anyPromoApplied = true;
            inApplicable:
            default:
              break;
          }
        }
      }

      // Handle without promos
      if (!anyPromoApplied) {
        newReceipt = await _handleWithoutPromosUseCase.call(
            params: HandlePromosUseCaseParams(
                receiptItemEntity: receiptItemEntity,
                receiptEntity: newReceipt));
      }

      // Recalculate receipt
      newReceipt = await _recalculateReceiptUseCase.call(params: newReceipt);

      dev.log(newReceipt.toString());
      emit(newReceipt);
    } catch (e, s) {
      dev.log(s.toString());
      ErrorHandler.presentErrorSnackBar(params.context, e.toString());
    }
  }

  void updateMopSelection(
      {required MopSelectionEntity mopSelectionEntity,
      required double amountReceived}) {
    final newState = state.copyWith(
        mopSelection: mopSelectionEntity, totalPayment: amountReceived);
    emit(newState);
  }

  void updateVouchersSelection({
    required List<VouchersSelectionEntity> vouchersSelectionEntity,
    required int vouchersAmount,
  }) {
    final newState = state.copyWith(
      vouchers: vouchersSelectionEntity,
      totalVoucher: vouchersAmount,
    );

    emit(newState);
  }

  void updateCustomer(CustomerEntity customerEntity) {
    emit(state.copyWith(customerEntity: customerEntity));
  }

  void removeReceiptItem(ReceiptItemEntity receiptItemEntity) {
    List<ReceiptItemEntity> newReceiptItems = [];

    for (final currentReceiptItem in state.receiptItems) {
      if (receiptItemEntity != currentReceiptItem) {
        newReceiptItems.add(currentReceiptItem);
      }
    }

    emit(state.copyWith(
      receiptItems: newReceiptItems,
      subtotal: state.subtotal - receiptItemEntity.totalGross,
      taxAmount: state.taxAmount - receiptItemEntity.taxAmount,
      grandTotal: state.grandTotal - receiptItemEntity.totalAmount,
    ));
  }

  void charge() async {
    final newState =
        state.copyWith(changed: state.totalPayment! - state.grandTotal);

    final ReceiptEntity? createdReceipt =
        await _saveReceiptUseCase.call(params: newState);

    if (createdReceipt != null) {
      if (state.toinvId != null) {
        await _deleteQueuedReceiptUseCase.call(params: state.toinvId);
      }
      emit(createdReceipt);
      try {
        await _printReceiptUsecase.call(params: createdReceipt);
        await _openCashDrawerUseCase.call();
      } catch (e) {
        print(e);
      }
      await GetIt.instance<InvoiceApi>().sendInvoice();
    }
  }

  void resetReceipt() {
    emit(ReceiptEntity(
      docNum:
          "S0001-${DateFormat('yyMMdd').format(DateTime.now())}${Random().nextInt(999) + 1000}/INV1",
      receiptItems: [],
      subtotal: 0,
      totalTax: 0,
      transStart: DateTime.now(),
      taxAmount: 0,
      grandTotal: 0,
      vouchers: [],
      promos: [],
    ));
  }

  void queueReceipt() async {
    await _queueReceiptUseCase.call(params: state);
    resetReceipt();
  }

  void retrieveFromQueue(ReceiptEntity receiptEntity) {
    emit(receiptEntity
      ..docNum =
          "S0001-${DateFormat('yyMMdd').format(DateTime.now())}${Random().nextInt(999) + 1000}/INV1");
  }

  void updateTotalAmountFromDiscount(double discValue) async {
    try {
      final ReceiptEntity newState =
          state.copyWith(discHeaderManual: discValue);

      ReceiptEntity? updatedReceipt =
          await _recalculateTaxUseCase.call(params: newState);

      dev.log("Emited Receipt - $updatedReceipt");

      emit(updatedReceipt);
    } catch (e) {
      dev.log("Error during tax recalculation: $e");
    }
  }

  Future<void> processReceiptBeforeCheckout(BuildContext context) async {
    try {
      ReceiptEntity newReceipt = state;

      for (final receiptItem in state.receiptItems) {
        List<PromotionsEntity?> availablePromos = [];
        availablePromos =
            await _checkPromoUseCase(params: receiptItem.itemEntity.toitmId);

        if (availablePromos.isNotEmpty) {
          for (final availablePromo in availablePromos) {
            switch (availablePromo!.promoType) {
              case 103:
                // Check applicability
                final CheckBuyXGetYApplicabilityResult
                    checkBuyXGetYApplicability =
                    await _checkBuyXGetYApplicabilityUseCase.call(
                        params: CheckBuyXGetYApplicabilityParams(
                  receiptEntity: state,
                  receiptItemEntity: receiptItem,
                  promo: availablePromo,
                ));

                if (!checkBuyXGetYApplicability.isApplicable) {
                  continue inApplicable;
                }

                // Show Pop Up
                final List<PromoBuyXGetYGetConditionAndItemEntity>?
                    selectedConditionAndItemYs = await showDialog<
                        List<PromoBuyXGetYGetConditionAndItemEntity>>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => PromoGetYDialog(
                    conditionAndItemYs:
                        checkBuyXGetYApplicability.conditionAndItemYs,
                    toprb: checkBuyXGetYApplicability.toprb!,
                  ),
                );
                if (selectedConditionAndItemYs == null) {
                  throw "Promo Buy X Get Y handled improperly";
                }

                // Handle X Items and Y Items (X Items, Y Items) => Receipt
                newReceipt = await _handlePromoBuyXGetYUseCase.call(
                    params: HandlePromoBuyXGetYUseCaseParams(
                        receiptItemEntity: receiptItem,
                        promo: availablePromo,
                        toprb: checkBuyXGetYApplicability.toprb,
                        receiptEntity: newReceipt,
                        conditionAndItemXs:
                            checkBuyXGetYApplicability.conditionAndItemXs,
                        existingReceiptItemXs:
                            checkBuyXGetYApplicability.existingReceiptItemXs,
                        conditionAndItemYs: selectedConditionAndItemYs));

                newReceipt =
                    await _recalculateReceiptUseCase.call(params: newReceipt);
                break;
              case 202:
              inApplicable:
              default:
                break;
            }
          }
        }
      }

      dev.log(newReceipt.toString());
      emit(newReceipt);
    } catch (e) {
      rethrow;
    }
  }
}

class AddUpdateReceiptItemsParams {
  final String? barcode;
  final ItemEntity? itemEntity;
  final double quantity;
  final BuildContext context;
  final void Function() onOpenPriceInputted;

  AddUpdateReceiptItemsParams({
    required this.barcode,
    required this.itemEntity,
    required this.quantity,
    required this.context,
    required this.onOpenPriceInputted,
  });
}
