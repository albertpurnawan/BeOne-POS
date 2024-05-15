import 'dart:developer' as dev;
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/invoice_service.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/delete_queued_receipt_by_docId.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_employee.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_by_barcode.dart';
import 'package:pos_fe/features/sales/domain/usecases/open_cash_drawer.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/queue_receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/save_receipt.dart';

part 'receipt_state.dart';

class ReceiptCubit extends Cubit<ReceiptEntity> {
  final GetItemByBarcodeUseCase _getItemByBarcodeUseCase;
  final SaveReceiptUseCase _saveReceiptUseCase;
  final GetEmployeeUseCase _getEmployeeUseCase;
  final PrintReceiptUseCase _printReceiptUsecase;
  final OpenCashDrawerUseCase _openCashDrawerUseCase;
  final QueueReceiptUseCase _queueReceiptUseCase;
  final DeleteQueuedReceiptUseCase _deleteQueuedReceiptUseCase;

  ReceiptCubit(
      this._getItemByBarcodeUseCase,
      this._saveReceiptUseCase,
      this._getEmployeeUseCase,
      this._printReceiptUsecase,
      this._openCashDrawerUseCase,
      this._queueReceiptUseCase,
      this._deleteQueuedReceiptUseCase)
      : super(ReceiptEntity(
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
    ReceiptItemEntity receiptItemEntityWithTopsb;
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
                    dev.log("CASE 103 SAME BARCODE");
                    final toprb = await GetIt.instance<AppDatabase>()
                        .promoBuyXGetYHeaderDao
                        .readByDocId(promo.promoId!, null);
                    final tprb2 = await GetIt.instance<AppDatabase>()
                        .promoBuyXGetYAssignStoreDao
                        .readByToprbId(promo.promoId!, null);
                    final tprb4 = await GetIt.instance<AppDatabase>()
                        .promoBuyXGetYGetConditionDao
                        .readByToprbId(promo.promoId!, null);
                    final itemY = await GetIt.instance<AppDatabase>()
                        .itemsDao
                        .readByToitmId(tprb4.toitmId!, null);

                    final totalGetItemY =
                        (currentReceiptItem.quantity / toprb!.maxMultiply);

                    final List<ReceiptItemEntity> itemYReceiptItems = state
                        .receiptItems
                        .where((element) =>
                            element.itemEntity.barcode == itemY!.barcode)
                        .toList();

                    final int itemYReceiptItemsLength =
                        itemYReceiptItems.length;

                    final double itemYsumQtyOnReceipt =
                        itemYReceiptItems.fold<double>(
                      0,
                      (previousValue, element) =>
                          previousValue + element.quantity,
                    );

                    if (tprb2.tostrId == topos[0].tostrId) {
                      // if (now.millisecondsSinceEpoch >=
                      //         startPromo.millisecondsSinceEpoch &&
                      //     now.millisecondsSinceEpoch <=
                      //         endPromo.millisecondsSinceEpoch) {
                      if (currentReceiptItem.promos.contains(promo)) {
                        dev.log("CRI WITH PROMO - $currentReceiptItem");
                        final double priceQty =
                            itemEntity.price * currentReceiptItem.quantity;
                        final double totalSellBarcode = priceQty;
                        final double totalGross = itemEntity.includeTax == 1
                            ? (priceQty * (100 / (100 + itemEntity.taxRate)))
                            : priceQty;
                        double taxAmount = itemEntity.includeTax == 1
                            ? (priceQty) - totalGross
                            : priceQty * (itemEntity.taxRate / 100);
                        final double totalAmount = totalGross + taxAmount;
                        isNewReceiptItem = false;
                        newReceiptItems.add(currentReceiptItem.copyWith(
                          totalGross: totalGross,
                        ));

                        subtotal += totalGross;
                        taxAmount += taxAmount;

                        if (currentReceiptItem.quantity >= toprb.minBuy &&
                            subtotal >= toprb.minPurchase &&
                            itemYsumQtyOnReceipt < toprb.maxGet) {
                          // GET ITEM Y
                          if (totalGetItemY > toprb.maxGet) {
                            final double itemYPriceQty = tprb4.sellingPrice *
                                (tprb4.quantity * toprb.maxGet);
                            final double itemYTotalSellBarcode = itemYPriceQty;
                            final double itemYTotalGross =
                                itemY!.includeTax == 1
                                    ? (itemYPriceQty *
                                        (100 / (100 + itemY.taxRate)))
                                    : itemYPriceQty;
                            final double itemYTaxAmountNewItem =
                                itemY.includeTax == 1
                                    ? (itemYPriceQty) - itemYTotalGross
                                    : itemYPriceQty * (itemY.taxRate / 100);
                            final double itemYTotalAmount =
                                itemYTotalGross + itemYTaxAmountNewItem;

                            newReceiptItems.add(ReceiptItemEntity(
                              quantity: tprb4.quantity * toprb.maxGet,
                              totalGross: itemYTotalGross,
                              itemEntity: itemY,
                              taxAmount: itemYTaxAmountNewItem,
                              sellingPrice: tprb4.sellingPrice,
                              totalAmount: itemYTotalAmount,
                              totalSellBarcode: itemYTotalSellBarcode,
                              promos: [promo],
                            ));

                            subtotal += itemYTotalGross;
                            taxAmount += itemYTaxAmountNewItem;
                          } else if (totalGetItemY <= toprb.maxGet &&
                              totalGetItemY >= 1) {
                            final double itemYPriceQty = tprb4.sellingPrice *
                                (tprb4.quantity * totalGetItemY.floor());
                            final double itemYTotalSellBarcode = itemYPriceQty;
                            final double itemYTotalGross =
                                itemY!.includeTax == 1
                                    ? (itemYPriceQty *
                                        (100 / (100 + itemY.taxRate)))
                                    : itemYPriceQty;
                            final double itemYTaxAmountNewItem =
                                itemY.includeTax == 1
                                    ? (itemYPriceQty) - itemYTotalGross
                                    : itemYPriceQty * (itemY.taxRate / 100);
                            final double itemYTotalAmount =
                                itemYTotalGross + itemYTaxAmountNewItem;

                            newReceiptItems.add(ReceiptItemEntity(
                              quantity: tprb4.quantity * totalGetItemY.floor(),
                              totalGross: itemYTotalGross,
                              itemEntity: itemY,
                              taxAmount: itemYTaxAmountNewItem,
                              sellingPrice: tprb4.sellingPrice,
                              totalAmount: itemYTotalAmount,
                              totalSellBarcode: itemYTotalSellBarcode,
                              promos: [promo],
                            ));
                            subtotal += itemYTotalGross;
                            taxAmount += itemYTaxAmountNewItem;
                          } else {
                            final double itemYPriceQty =
                                tprb4.sellingPrice * tprb4.quantity;
                            final double itemYTotalSellBarcode = itemYPriceQty;
                            final double itemYTotalGross =
                                itemY!.includeTax == 1
                                    ? (itemYPriceQty *
                                        (100 / (100 + itemY.taxRate)))
                                    : itemYPriceQty;
                            final double itemYTaxAmountNewItem =
                                itemY.includeTax == 1
                                    ? (itemYPriceQty) - itemYTotalGross
                                    : itemYPriceQty * (itemY.taxRate / 100);
                            final double itemYTotalAmount =
                                itemYTotalGross + itemYTaxAmountNewItem;

                            newReceiptItems.add(ReceiptItemEntity(
                              quantity: tprb4.quantity,
                              totalGross: itemYTotalGross,
                              itemEntity: itemY,
                              taxAmount: itemYTaxAmountNewItem,
                              sellingPrice: tprb4.sellingPrice,
                              totalAmount: itemYTotalAmount,
                              totalSellBarcode: itemYTotalSellBarcode,
                              promos: [promo],
                            ));
                            subtotal += itemYTotalGross;
                            taxAmount += itemYTaxAmountNewItem;
                          }
                        }
                      }
                      // }
                    }

                    break;
                  case 202:
                    final topsb = await GetIt.instance<AppDatabase>()
                        .promoHargaSpesialHeaderDao
                        .readByDocId(promo.promoId!, null);
                    final tpsb1 = await GetIt.instance<AppDatabase>()
                        .promoHargaSpesialBuyDao
                        .readByTopsbId(promo.promoId!, null);
                    final tpsb4 = await GetIt.instance<AppDatabase>()
                        .promoHargaSpesialAssignStoreDao
                        .readByTopsbId(promo.promoId!, null);
                    final topos = await GetIt.instance<AppDatabase>()
                        .posParameterDao
                        .readAll();
                    bool promoAlreadyApplied =
                        currentReceiptItem.promos.contains(promo);
                    double? specialPrice = itemEntity.price - tpsb1.price;

                    // check store participated in promo or not
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
                      // check promo already applied
                      dev.log("promo - $promoAlreadyApplied");
                      if (!promoAlreadyApplied) {
                        // check promo buy condition: quantity
                        if (currentReceiptItem.quantity >= tpsb1.qty) {
                          dev.log("Item Fulfilled Conditions");

                          if (topsb!.promoAlias == 1) {
                            if (currentReceiptItem.quantity >= tpsb1.qty) {
                              specialPrice *= 1;
                            } else {
                              specialPrice = 0;
                            }
                          } else {
                            if (currentReceiptItem.quantity <=
                                topsb.maxPurchaseTransaction) {
                              specialPrice *=
                                  ((currentReceiptItem.quantity / tpsb1.qty)
                                      .floor());
                            } else if (currentReceiptItem.quantity >
                                (topsb.maxPurchaseTransaction / tpsb1.qty)) {
                              specialPrice *=
                                  ((topsb.maxPurchaseTransaction / tpsb1.qty)
                                      .floor());
                            } else {
                              specialPrice = 0;
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
                              currentReceiptItem.itemEntity.includeTax == 1
                                  ? (priceQty) - currentReceiptItem.totalGross
                                  : priceQty *
                                      (currentReceiptItem.itemEntity.taxRate /
                                          100);
                          currentReceiptItem.totalAmount =
                              currentReceiptItem.totalGross +
                                  currentReceiptItem.taxAmount;
                          isNewReceiptItem = false;

                          newReceiptItems.add(ReceiptItemEntity(
                            quantity: currentReceiptItem.quantity,
                            totalGross:
                                currentReceiptItem.totalGross - specialPrice,
                            itemEntity: currentReceiptItem.itemEntity,
                            taxAmount: currentReceiptItem.taxAmount,
                            sellingPrice: currentReceiptItem.sellingPrice,
                            totalAmount: currentReceiptItem.totalAmount,
                            totalSellBarcode:
                                currentReceiptItem.totalSellBarcode,
                            promos: [promo],
                            discAmount: specialPrice,
                          ));

                          subtotal +=
                              currentReceiptItem.totalGross - specialPrice;
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
                          if (currentReceiptItem.quantity >= tpsb1.qty) {
                            specialPrice *= 1;
                          } else {
                            specialPrice = 0;
                          }
                        } else {
                          if (currentReceiptItem.quantity <=
                              topsb.maxPurchaseTransaction) {
                            specialPrice *=
                                ((currentReceiptItem.quantity / tpsb1.qty)
                                    .floor());
                          } else if (currentReceiptItem.quantity >
                              (topsb.maxPurchaseTransaction / tpsb1.qty)) {
                            specialPrice *=
                                ((topsb.maxPurchaseTransaction / tpsb1.qty)
                                    .floor());
                          } else {
                            specialPrice = 0;
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
                            currentReceiptItem.itemEntity.includeTax == 1
                                ? (priceQty) - currentReceiptItem.totalGross
                                : priceQty *
                                    (currentReceiptItem.itemEntity.taxRate /
                                        100);
                        currentReceiptItem.totalAmount =
                            currentReceiptItem.totalGross +
                                currentReceiptItem.taxAmount;
                        isNewReceiptItem = false;

                        newReceiptItems.add(ReceiptItemEntity(
                          quantity: currentReceiptItem.quantity,
                          totalGross:
                              currentReceiptItem.totalGross - specialPrice,
                          itemEntity: currentReceiptItem.itemEntity,
                          taxAmount: currentReceiptItem.taxAmount,
                          sellingPrice: currentReceiptItem.sellingPrice,
                          totalAmount: currentReceiptItem.totalAmount,
                          totalSellBarcode: currentReceiptItem.totalSellBarcode,
                          promos: [promo],
                          discAmount: specialPrice,
                        ));

                        subtotal +=
                            currentReceiptItem.totalGross - specialPrice;
                        taxAmount += currentReceiptItem.taxAmount;
                      }
                    } else {
                      dev.log("Time Not Fulfilled");
                    }

                    break;

                  default:
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
                dev.log("CASE 103");
                final toprb = await GetIt.instance<AppDatabase>()
                    .promoBuyXGetYHeaderDao
                    .readByDocId(promo.promoId!, null);
                final tprb4 = await GetIt.instance<AppDatabase>()
                    .promoBuyXGetYGetConditionDao
                    .readByToprbId(promo.promoId!, null);
                final itemY = await GetIt.instance<AppDatabase>()
                    .itemsDao
                    .readByToitmId(tprb4.toitmId!, null);

                final totalGetItemY = (quantity / toprb!.maxMultiply);

                // ADD ITEM X
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
                  promos: [promo],
                ));
                subtotal += totalGross;
                taxAmount += taxAmountNewItem;

                if (quantity >= toprb.minBuy && subtotal >= toprb.minPurchase) {
                  // GET ITEM Y

                  if (totalGetItemY > toprb.maxGet) {
                    final double itemYPriceQty =
                        tprb4.sellingPrice * (tprb4.quantity * toprb.maxGet);
                    final double itemYTotalSellBarcode = itemYPriceQty;
                    final double itemYTotalGross = itemY!.includeTax == 1
                        ? (itemYPriceQty * (100 / (100 + itemY.taxRate)))
                        : itemYPriceQty;
                    final double itemYTaxAmountNewItem = itemY.includeTax == 1
                        ? (itemYPriceQty) - itemYTotalGross
                        : itemYPriceQty * (itemY.taxRate / 100);
                    final double itemYTotalAmount =
                        itemYTotalGross + itemYTaxAmountNewItem;

                    newReceiptItems.add(ReceiptItemEntity(
                      quantity: tprb4.quantity * toprb.maxGet,
                      totalGross: itemYTotalGross,
                      itemEntity: itemY,
                      taxAmount: itemYTaxAmountNewItem,
                      sellingPrice: tprb4.sellingPrice,
                      totalAmount: itemYTotalAmount,
                      totalSellBarcode: itemYTotalSellBarcode,
                      promos: [promo],
                    ));
                    subtotal += itemYTotalGross;
                    taxAmount += itemYTaxAmountNewItem;
                  } else if (totalGetItemY <= toprb.maxGet &&
                      totalGetItemY >= 1) {
                    final double itemYPriceQty = tprb4.sellingPrice *
                        (tprb4.quantity * totalGetItemY.floor());
                    final double itemYTotalSellBarcode = itemYPriceQty;
                    final double itemYTotalGross = itemY!.includeTax == 1
                        ? (itemYPriceQty * (100 / (100 + itemY.taxRate)))
                        : itemYPriceQty;
                    final double itemYTaxAmountNewItem = itemY.includeTax == 1
                        ? (itemYPriceQty) - itemYTotalGross
                        : itemYPriceQty * (itemY.taxRate / 100);
                    final double itemYTotalAmount =
                        itemYTotalGross + itemYTaxAmountNewItem;

                    newReceiptItems.add(ReceiptItemEntity(
                      quantity: tprb4.quantity * totalGetItemY.floor(),
                      totalGross: itemYTotalGross,
                      itemEntity: itemY,
                      taxAmount: itemYTaxAmountNewItem,
                      sellingPrice: tprb4.sellingPrice,
                      totalAmount: itemYTotalAmount,
                      totalSellBarcode: itemYTotalSellBarcode,
                      promos: [promo],
                    ));
                    subtotal += itemYTotalGross;
                    taxAmount += itemYTaxAmountNewItem;
                  } else {
                    final double itemYPriceQty =
                        tprb4.sellingPrice * tprb4.quantity;
                    final double itemYTotalSellBarcode = itemYPriceQty;
                    final double itemYTotalGross = itemY!.includeTax == 1
                        ? (itemYPriceQty * (100 / (100 + itemY.taxRate)))
                        : itemYPriceQty;
                    final double itemYTaxAmountNewItem = itemY.includeTax == 1
                        ? (itemYPriceQty) - itemYTotalGross
                        : itemYPriceQty * (itemY.taxRate / 100);
                    final double itemYTotalAmount =
                        itemYTotalGross + itemYTaxAmountNewItem;

                    newReceiptItems.add(ReceiptItemEntity(
                      quantity: tprb4.quantity,
                      totalGross: itemYTotalGross,
                      itemEntity: itemY,
                      taxAmount: itemYTaxAmountNewItem,
                      sellingPrice: tprb4.sellingPrice,
                      totalAmount: itemYTotalAmount,
                      totalSellBarcode: itemYTotalSellBarcode,
                      promos: [promo],
                    ));
                    subtotal += itemYTotalGross;
                    taxAmount += itemYTaxAmountNewItem;
                  }
                }
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

                double specialPrice = itemEntity.price - tpsb1.price;

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
                          specialPrice = (quantity * itemEntity.price) -
                              ((el.price * el.qty) +
                                  (itemEntity.price * (quantity - el.qty)));
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
                        specialPrice = actualTotalPrice - expectedSubtotal;
                      } else if (quantity >
                          (topsb.maxPurchaseTransaction / tpsb1.qty)) {
                        specialPrice *= topsb.maxPurchaseTransaction;
                      } else {
                        specialPrice = 0;
                      }
                    }

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
                      totalGross: totalGross - specialPrice,
                      itemEntity: itemWithPromo,
                      taxAmount: taxAmountNewItem,
                      sellingPrice: itemWithPromo.price,
                      totalAmount: totalAmount,
                      totalSellBarcode: totalSellBarcode,
                      promos: [promo],
                      discAmount: specialPrice,
                    ));

                    promoApplied = true;
                    promotionsApplied.add(promo);
                    subtotal += totalGross - specialPrice;
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
              default:
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
}
