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
        ));

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
    ReceiptItemEntity? receiptItemEntityAfterPromoCheck;

    for (final currentReceiptItem in state.receiptItems) {
      if (currentReceiptItem.itemEntity.barcode == itemBarcode) {
        currentReceiptItem.quantity += quantity;
        dev.log("QTY $quantity");
        dev.log("QTY ${currentReceiptItem.quantity}");
        receiptItemEntityAfterPromoCheck = currentReceiptItem;
        // check promo
        final checkPromoUseCase = GetIt.instance<CheckPromoUseCase>();
        final promos = await checkPromoUseCase.call(params: itemEntity.toitmId);

        if (promos.isNotEmpty) {
          for (final promo in promos) {
            if (promo!.toitmId == itemEntity.toitmId) {
              switch (promo.promoType) {
                case 202:
                  final tpsb4 = await GetIt.instance<AppDatabase>()
                      .promoHargaSpesialAssignStoreDao
                      .readByTopsbId(promo.promoId!, null);
                  final topos = await GetIt.instance<AppDatabase>()
                      .posParameterDao
                      .readAll();
                  bool promoAlreadyApplied =
                      currentReceiptItem.promos.contains(promo);
                  if (tpsb4.tostrId == topos[0].tostrId) {
                    // validate for days
                    if (!promoAlreadyApplied) {
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
                                : currentReceiptItem.itemEntity.dpp -
                                    tpsb1.price,
                            dpp:
                                currentReceiptItem.itemEntity.dpp - tpsb1.price,
                          ),
                          promos: [...currentReceiptItem.promos, promo],
                        );
                        promotionsApplied.add(promo);
                      }
                    }
                    break;
                  }

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
        dev.log("$isNewReceiptItem");
        isNewReceiptItem = false;
        dev.log("$isNewReceiptItem");
        newReceiptItems.add(receiptItemEntityAfterPromoCheck);
      } else {
        dev.log("$isNewReceiptItem");
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
      dev.log("QTY $quantity");
      if (promos.isNotEmpty) {
        dev.log("HEREEEE");
        for (final promo in promos) {
          if (promo!.toitmId == itemEntity.toitmId) {
            switch (promo.promoType) {
              case 202:
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
                break;
              default:
            }
          }
        }
      }

      final double priceQty = itemWithPromo!.price * quantity;
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
        itemEntity: itemWithPromo,
        taxAmount: taxAmountNewItem,
        sellingPrice: itemWithPromo.price,
        totalAmount: totalAmount,
        totalSellBarcode: totalSellBarcode,
        promos: promotionsApplied,
      ));
      subtotal += totalGross;
      taxAmount += taxAmountNewItem;
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
                  bool promoAlreadyApplied =
                      currentReceiptItem.promos.contains(promo);

                  if (!promoAlreadyApplied) {
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
        dev.log("$isNewReceiptItem");
        isNewReceiptItem = false;
        dev.log("$isNewReceiptItem");
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
      dev.log("$isNewReceiptItem on isNewReceiptItem if");
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
                break;
              default:
            }
          }
        }
      }

      final double priceQty = itemWithPromo!.price * quantity;
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
        itemEntity: itemWithPromo,
        taxAmount: taxAmountNewItem,
        sellingPrice: itemWithPromo.price,
        totalAmount: totalAmount,
        totalSellBarcode: totalSellBarcode,
        promos: promotionsApplied,
      ));
      subtotal += totalGross;
      taxAmount += taxAmountNewItem;
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

    return addOrUpdateReceiptItemWithOpenPrice(itemEntity, 1, null);
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
