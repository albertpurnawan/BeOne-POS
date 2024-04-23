import 'dart:math';
import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/invoice_service.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
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

    dev.log(state.toString());
    dev.log("OWPJDOPIJOKJDSLIDHSUIDGHISUGDHIUSGD");

    List<ReceiptItemEntity> newReceiptItems = [];
    double subtotal = 0;
    double taxAmount = 0;
    bool isNewReceiptItem = true;
    for (final currentReceiptItem in state.receiptItems) {
      if (currentReceiptItem.itemEntity.barcode == itemBarcode) {
        currentReceiptItem.quantity += quantity;
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
      } else {
        newReceiptItems.add(currentReceiptItem);
      }
      subtotal += currentReceiptItem.totalGross;
      taxAmount += currentReceiptItem.taxAmount;
    }

    if (isNewReceiptItem) {
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
    print(newState.taxAmount);
    print("terjadi");
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
    for (final currentReceiptItem in state.receiptItems) {
      if (currentReceiptItem.itemEntity.barcode == priceSetItemEntity.barcode &&
          currentReceiptItem.itemEntity.price == priceSetItemEntity.price) {
        currentReceiptItem.quantity += quantity;
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
      } else {
        newReceiptItems.add(currentReceiptItem);
      }
      subtotal += currentReceiptItem.totalGross;
      taxAmount += currentReceiptItem.taxAmount;
    }

    if (isNewReceiptItem) {
      final double priceQty = priceSetItemEntity.price * quantity;
      final double totalSellBarcode = priceQty;
      final double totalGross = priceSetItemEntity.includeTax == 1
          ? (priceQty * (100 / (100 + priceSetItemEntity.taxRate)))
          : priceQty;
      final double taxAmountNewItem = priceSetItemEntity.includeTax == 1
          ? (priceQty) - totalGross
          : priceQty * (priceSetItemEntity.taxRate / 100);
      final double totalAmount = totalGross + taxAmountNewItem;
      newReceiptItems.add(ReceiptItemEntity(
        quantity: quantity,
        totalGross: totalGross,
        itemEntity: priceSetItemEntity,
        taxAmount: taxAmountNewItem,
        sellingPrice: priceSetItemEntity.price,
        totalAmount: totalAmount,
        totalSellBarcode: totalSellBarcode,
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

  void addOrUpdateReceiptItemsBySearch(ItemEntity itemEntity) {
    dev.log(state.toString());
    dev.log("OWPJDOPIJOKJDSLIDHSUIDGHISUGDHIUSGD");
    return addOrUpdateReceiptItemWithOpenPrice(itemEntity, 1, null);
  }

  void updateMopSelection(
      {required MopSelectionEntity mopSelectionEntity,
      required double amountReceived}) {
    final newState = state.copyWith(
        mopSelection: mopSelectionEntity, totalPayment: amountReceived);
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
