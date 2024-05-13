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
      double itemSubtotal = 0;
      double itemTaxAmount = 0;

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

                    final totalGetItemY = (quantity / toprb!.maxMultiply);

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
                        final double taxAmount = itemEntity.includeTax == 1
                            ? (priceQty) - totalGross
                            : priceQty * (itemEntity.taxRate / 100);
                        final double totalAmount = totalGross + taxAmount;
                        isNewReceiptItem = false;
                        newReceiptItems.add(currentReceiptItem.copyWith(
                          totalGross: totalGross,
                        ));
                        dev.log("NRI - $newReceiptItems");
                        itemSubtotal += totalGross;
                        itemTaxAmount += taxAmount;
                        // if (currentReceiptItem.quantity >= toprb.minBuy) {}
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
                    final tpsb2 = await GetIt.instance<AppDatabase>()
                        .promoHargaSpesialAssignStoreDao
                        .readByTopsbId(promo.promoId!, null);

                    // ReceiptItemEntity receiptItemEntityWithTopsb =
                    //     currentReceiptItem;
                    if (tpsb2.tostrId == topos[0].tostrId) {
                      if (now.millisecondsSinceEpoch >=
                              startPromo.millisecondsSinceEpoch &&
                          now.millisecondsSinceEpoch <=
                              endPromo.millisecondsSinceEpoch) {
                        if (currentReceiptItem.promos.contains(promo)) {
                          promoApplied = true;

                          receiptItemEntityWithTopsb =
                              currentReceiptItem.copyWith(
                            itemEntity: currentReceiptItem.itemEntity,
                            promos: currentReceiptItem.promos,
                            quantity: currentReceiptItem.quantity,
                          );

                          final List<ReceiptItemEntity> existingReceiptItems =
                              state
                                  .receiptItems
                                  .where((element) =>
                                      element.itemEntity.barcode == itemBarcode)
                                  .toList();
                          final int existingReceiptItemsLength =
                              existingReceiptItems.length;
                          final double sumQtyOnReceipt = existingReceiptItems
                              .map((e) => e.quantity)
                              .reduce((value, element) => value + element);

                          if (sumQtyOnReceipt >=
                              topsb!.maxPurchaseTransaction) {
                            currentReceiptItem.quantity -= quantity;

                            if (sumQtyOnReceipt - quantity <
                                topsb.maxPurchaseTransaction) {
                              final double insertedQty =
                                  topsb.maxPurchaseTransaction -
                                      currentReceiptItem.quantity;
                              final double newQty = quantity - insertedQty;
                              // update

                              // ADD NEW RECEIPT ITEM, PARTIAL OVER QTY
                              if (existingReceiptItemsLength == 1) {
                                dev.log("Case Row == 1");
                                currentReceiptItem.quantity += newQty;

                                final double priceQty =
                                    itemEntity.price * newQty;
                                final double totalSellBarcode = priceQty;
                                final double totalGross =
                                    itemEntity.includeTax == 1
                                        ? (priceQty *
                                            (100 / (100 + itemEntity.taxRate)))
                                        : priceQty;
                                final double taxAmount =
                                    itemEntity.includeTax == 1
                                        ? (priceQty) - totalGross
                                        : priceQty * (itemEntity.taxRate / 100);
                                final double totalAmount =
                                    totalGross + taxAmount;
                                isNewReceiptItem = false;

                                newReceiptItems.add(ReceiptItemEntity(
                                    quantity: newQty,
                                    totalGross: totalGross,
                                    itemEntity: itemEntity,
                                    taxAmount: taxAmount,
                                    sellingPrice: itemEntity.price,
                                    totalAmount: totalAmount,
                                    totalSellBarcode: totalSellBarcode,
                                    promos: []));

                                itemSubtotal += totalGross;
                                itemTaxAmount += taxAmount;
                              } else if (currentReceiptItem.promos.isEmpty) {
                                dev.log("Update Case PromosEmty");
                                currentReceiptItem.quantity += quantity;
                              }
                            } else if (existingReceiptItemsLength == 1) {
                              // add
                              dev.log("ADD CASE ROW == 1");
                              final double priceQty =
                                  itemEntity.price * quantity;
                              final double totalSellBarcode = priceQty;
                              final double totalGross =
                                  itemEntity.includeTax == 1
                                      ? (priceQty *
                                          (100 / (100 + itemEntity.taxRate)))
                                      : priceQty;
                              final double taxAmount =
                                  itemEntity.includeTax == 1
                                      ? (priceQty) - totalGross
                                      : priceQty * (itemEntity.taxRate / 100);
                              final double totalAmount = totalGross + taxAmount;
                              isNewReceiptItem = false;

                              newReceiptItems.add(ReceiptItemEntity(
                                  quantity: quantity,
                                  totalGross: totalGross,
                                  itemEntity: itemEntity,
                                  taxAmount: taxAmount,
                                  sellingPrice: itemEntity.price,
                                  totalAmount: totalAmount,
                                  totalSellBarcode: totalSellBarcode,
                                  promos: []));

                              itemSubtotal += totalGross;
                              itemTaxAmount += taxAmount;
                            } else if (currentReceiptItem.promos.isEmpty) {
                              // update yg ga kena diskon
                              dev.log("UPDATE CASE ROW is 2? promoEmpty");
                              currentReceiptItem.quantity += quantity;
                            }
                            //balikin ke nilai awal
                            dev.log("ADD DEFAULT?");

                            currentReceiptItem = currentReceiptItem.copyWith(
                              itemEntity:
                                  currentReceiptItem.itemEntity.copyWith(
                                price: itemEntity.includeTax == 1
                                    ? (currentReceiptItem.itemEntity.dpp +
                                            tpsb1.price) *
                                        ((100 + itemEntity.taxRate) / 100)
                                    : currentReceiptItem.itemEntity.dpp -
                                        tpsb1.price,
                                dpp: currentReceiptItem.itemEntity.dpp -
                                    tpsb1.price,
                              ),
                              promos: [...currentReceiptItem.promos, promo],
                              quantity: currentReceiptItem.quantity,
                            );

                            // ADD NEW RECEIPT ITEM, OVER QTY
                            final double priceQty = itemEntity.price * quantity;
                            final double totalSellBarcode = priceQty;
                            final double totalGross = itemEntity.includeTax == 1
                                ? (priceQty *
                                    (100 / (100 + itemEntity.taxRate)))
                                : priceQty;
                            final double taxAmount = itemEntity.includeTax == 1
                                ? (priceQty) - totalGross
                                : priceQty * (itemEntity.taxRate / 100);
                            final double totalAmount = totalGross + taxAmount;
                            isNewReceiptItem = false;

                            newReceiptItems.add(ReceiptItemEntity(
                                quantity: quantity,
                                totalGross: totalGross,
                                itemEntity: itemEntity,
                                taxAmount: taxAmount,
                                sellingPrice: itemEntity.price,
                                totalAmount: totalAmount,
                                totalSellBarcode: totalSellBarcode,
                                promos: []));

                            itemSubtotal += totalGross;
                            itemTaxAmount += taxAmount;
                          }

                          final double priceQty =
                              receiptItemEntityWithTopsb.itemEntity.price *
                                  receiptItemEntityWithTopsb.quantity;
                          receiptItemEntityWithTopsb.totalSellBarcode =
                              priceQty;
                          receiptItemEntityWithTopsb.totalGross =
                              receiptItemEntityWithTopsb
                                          .itemEntity.includeTax ==
                                      1
                                  ? (priceQty *
                                      (100 /
                                          (100 +
                                              receiptItemEntityWithTopsb
                                                  .itemEntity.taxRate)))
                                  : priceQty;
                          receiptItemEntityWithTopsb.taxAmount =
                              receiptItemEntityWithTopsb
                                          .itemEntity.includeTax ==
                                      1
                                  ? (priceQty) -
                                      receiptItemEntityWithTopsb.totalGross
                                  : priceQty *
                                      (receiptItemEntityWithTopsb
                                              .itemEntity.taxRate /
                                          100);
                          receiptItemEntityWithTopsb.totalAmount =
                              receiptItemEntityWithTopsb.totalGross +
                                  receiptItemEntityWithTopsb.taxAmount;
                          isNewReceiptItem = false;

                          // ADD RECEIPT ITEM PROMO NOT EMPTY
                          dev.log("ADD RECEIPT ITEM PROMO NOT EMPTY");
                          newReceiptItems.add(receiptItemEntityWithTopsb);

                          itemSubtotal += receiptItemEntityWithTopsb.totalGross;
                          itemTaxAmount += receiptItemEntityWithTopsb.taxAmount;
                        } else {
                          promoApplied = false;

                          if (currentReceiptItem.quantity >= tpsb1.qty &&
                              currentReceiptItem.quantity <=
                                  topsb!.maxPurchaseTransaction) {
                            receiptItemEntityWithTopsb =
                                currentReceiptItem.copyWith(
                              itemEntity:
                                  currentReceiptItem.itemEntity.copyWith(
                                price: itemEntity.includeTax == 1
                                    ? (currentReceiptItem.itemEntity.dpp -
                                            tpsb1.price) *
                                        ((100 + itemEntity.taxRate) / 100)
                                    : currentReceiptItem.itemEntity.dpp -
                                        tpsb1.price,
                                dpp: currentReceiptItem.itemEntity.dpp -
                                    tpsb1.price,
                              ),
                              promos: [...currentReceiptItem.promos, promo],
                              quantity: currentReceiptItem.quantity,
                            );
                            promotionsApplied.add(promo);
                            final double priceQty =
                                receiptItemEntityWithTopsb.itemEntity.price *
                                    receiptItemEntityWithTopsb.quantity;
                            receiptItemEntityWithTopsb.totalSellBarcode =
                                priceQty;
                            receiptItemEntityWithTopsb.totalGross =
                                receiptItemEntityWithTopsb
                                            .itemEntity.includeTax ==
                                        1
                                    ? (priceQty *
                                        (100 /
                                            (100 +
                                                receiptItemEntityWithTopsb
                                                    .itemEntity.taxRate)))
                                    : priceQty;
                            receiptItemEntityWithTopsb.taxAmount =
                                receiptItemEntityWithTopsb
                                            .itemEntity.includeTax ==
                                        1
                                    ? (priceQty) -
                                        receiptItemEntityWithTopsb.totalGross
                                    : priceQty *
                                        (receiptItemEntityWithTopsb
                                                .itemEntity.taxRate /
                                            100);
                            receiptItemEntityWithTopsb.totalAmount =
                                receiptItemEntityWithTopsb.totalGross +
                                    receiptItemEntityWithTopsb.taxAmount;
                            isNewReceiptItem = false;

                            // ADD RECEIPT ITEM PROMO EMPTY
                            dev.log("ADD RECEIPT ITEM PROMO EMPTY");
                            newReceiptItems.add(receiptItemEntityWithTopsb);
                            // dev.log('newReceipt - $newReceiptItems');
                            itemSubtotal +=
                                receiptItemEntityWithTopsb.totalGross;
                            itemTaxAmount +=
                                receiptItemEntityWithTopsb.taxAmount;
                            promoApplied = true;
                          }
                        }
                      }
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

          itemSubtotal += currentReceiptItem.totalGross;
          itemTaxAmount += currentReceiptItem.taxAmount;
        }
      } else {
        newReceiptItems.add(currentReceiptItem);
        itemSubtotal += currentReceiptItem.totalGross;
        itemTaxAmount += currentReceiptItem.taxAmount;
      }
      subtotal += itemSubtotal;
      taxAmount += itemTaxAmount;
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
                  } else if (totalGetItemY <= 3 && totalGetItemY >= 1) {
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
                final tpsb1 = await GetIt.instance<AppDatabase>()
                    .promoHargaSpesialBuyDao
                    .readByTopsbId(promo.promoId!, null);

                if (quantity >= tpsb1.qty) {
                  // Apply promo directly to itemWithPromo
                  itemWithPromo = itemEntity.copyWith(
                    price: itemEntity.includeTax == 1
                        ? (itemEntity.dpp - tpsb1.price) *
                            ((100 + itemEntity.taxRate) / 100)
                        : (itemEntity.dpp - tpsb1.price),
                    dpp: itemEntity.dpp - tpsb1.price,
                  );
                  // Calculate totals
                  dev.log("New Receipt With Promo");
                  final double priceQty = itemWithPromo.price * quantity;
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
                    itemEntity: itemWithPromo,
                    taxAmount: taxAmountNewItem,
                    sellingPrice: itemWithPromo.price,
                    totalAmount: totalAmount,
                    totalSellBarcode: totalSellBarcode,
                    promos: [promo],
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
