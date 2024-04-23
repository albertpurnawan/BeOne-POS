import 'dart:math';

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
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
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

  void updateQuantity(ReceiptItemEntity receiptItemEntity, double quantity) {
    List<ReceiptItemEntity> newReceiptItems = [];
    double subtotal = 0;
    double taxAmount = 0;

    for (final currentReceiptItem in state.receiptItems) {
      if (currentReceiptItem.itemEntity.barcode ==
          receiptItemEntity.itemEntity.barcode) {
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
        newReceiptItems.add(currentReceiptItem);
      } else {
        newReceiptItems.add(currentReceiptItem);
      }
      subtotal += currentReceiptItem.totalGross;
      taxAmount += currentReceiptItem.taxAmount;
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
      // final StoreMasterEntity storeMaster = await _getStoreMasterUseCase.call();
      // final bool taxByItem = storeMaster.taxBy == 1;
      // final double dpp = taxByItem ? (100/(100+itemEntity.taxRate)) * price;
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

    // List<ReceiptItemEntity> newReceiptItems = [];
    // double totalPrice = 0;
    // double totalTax = 0;
    // bool isNewReceiptItem = true;
    // for (final currentReceiptItem in state.receiptItems) {
    //   if (currentReceiptItem.itemEntity.barcode == priceSetItemEntity.barcode &&
    //       currentReceiptItem.itemEntity.price == priceSetItemEntity.price) {
    //     currentReceiptItem.quantity += quantity;
    //     currentReceiptItem.subtotal = priceSetItemEntity.includeTax == 1
    //         ? (priceSetItemEntity.price *
    //             currentReceiptItem.quantity *
    //             (100 / (100 + priceSetItemEntity.taxRate)))
    //         : priceSetItemEntity.price * currentReceiptItem.quantity;
    //     currentReceiptItem.taxAmount = priceSetItemEntity.includeTax == 1
    //         ? (priceSetItemEntity.price * currentReceiptItem.quantity) -
    //             currentReceiptItem.subtotal
    //         : priceSetItemEntity.price *
    //             currentReceiptItem.quantity *
    //             (priceSetItemEntity.taxRate / 100);
    //     isNewReceiptItem = false;
    //     newReceiptItems.add(currentReceiptItem);
    //   } else {
    //     newReceiptItems.add(currentReceiptItem);
    //   }
    //   totalPrice += currentReceiptItem.subtotal;
    //   totalTax += currentReceiptItem.taxAmount;
    // }

    // if (isNewReceiptItem) {
    //   final double subtotal = priceSetItemEntity.includeTax == 1
    //       ? (priceSetItemEntity.price *
    //           quantity *
    //           (100 / (100 + priceSetItemEntity.taxRate)))
    //       : priceSetItemEntity.price * quantity;
    //   final double taxAmount = priceSetItemEntity.includeTax == 1
    //       ? (priceSetItemEntity.price * quantity) - subtotal
    //       : priceSetItemEntity.price *
    //           quantity *
    //           (priceSetItemEntity.taxRate / 100);
    //   newReceiptItems.add(ReceiptItemEntity(
    //     quantity: quantity,
    //     subtotal: subtotal,
    //     itemEntity: priceSetItemEntity,
    //     id: null,
    //     taxAmount: taxAmount,
    //   ));
    //   totalPrice += subtotal;
    //   totalTax += taxAmount;
    // }

    // final ReceiptEntity newState = state.copyWith(
    //   receiptItems: newReceiptItems,
    //   totalPrice: totalPrice,
    //   totalTax: totalTax,
    // );
    // emit(newState);
  }

  void addOrUpdateReceiptItemsBySearch(ItemEntity itemEntity) {
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
    print("total payment ${state.totalPayment!}");
    print("grandTotal ${state.grandTotal}");
    final newState =
        state.copyWith(changed: state.totalPayment! - state.grandTotal);
    final ReceiptEntity? createdReceipt =
        await _saveReceiptUseCase.call(params: newState);
    if (createdReceipt != null) {
      print(" $createdReceipt");
      await _deleteQueuedReceiptUseCase.call(params: state.toinvId);
      emit(createdReceipt);
      try {
        await _printReceiptUsecase.call(params: createdReceipt);
      } catch (e) {
        print(e);
      }
      await _openCashDrawerUseCase.call();
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
    final ReceiptEntity? queuedReceipt =
        await _queueReceiptUseCase.call(params: state);
    print("ini adalah quequed receipt");
    print(queuedReceipt);
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

  void retrieveFromQueue(ReceiptEntity receiptEntity) {
    emit(receiptEntity);
  }
}
