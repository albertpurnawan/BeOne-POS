import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_employee.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_by_barcode.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/save_receipt.dart';

part 'receipt_state.dart';

class ReceiptCubit extends Cubit<ReceiptEntity> {
  final GetItemByBarcodeUseCase _getItemByBarcodeUseCase;
  final SaveReceiptUseCase _saveReceiptUseCase;
  final GetEmployeeUseCase _getEmployeeUseCase;
  final GetStoreMasterUseCase _getStoreMasterUseCase;

  ReceiptCubit(this._getItemByBarcodeUseCase, this._saveReceiptUseCase,
      this._getEmployeeUseCase, this._getStoreMasterUseCase)
      : super(ReceiptEntity(
          docNum:
              "S0001-${DateFormat('yyMMdd').format(DateTime.now())}${Random().nextInt(999) + 1000}/INV1",
          receiptItems: [],
          totalPrice: 0,
          totalTax: 0,
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
    double totalPrice = 0;
    double totalTax = 0;
    bool isNewReceiptItem = true;
    for (final currentReceiptItem in state.receiptItems) {
      if (currentReceiptItem.itemEntity.barcode == itemBarcode) {
        currentReceiptItem.quantity += quantity;
        currentReceiptItem.subtotal = itemEntity.includeTax == 1
            ? (itemEntity.price *
                currentReceiptItem.quantity *
                (100 / (100 + itemEntity.taxRate)))
            : itemEntity.price * currentReceiptItem.quantity;
        currentReceiptItem.taxAmount = itemEntity.includeTax == 1
            ? (itemEntity.price * currentReceiptItem.quantity) -
                currentReceiptItem.subtotal
            : itemEntity.price *
                currentReceiptItem.quantity *
                (itemEntity.taxRate / 100);
        isNewReceiptItem = false;
        newReceiptItems.add(currentReceiptItem);
      } else {
        newReceiptItems.add(currentReceiptItem);
      }
      totalPrice += currentReceiptItem.subtotal;
      totalTax += currentReceiptItem.taxAmount;
    }

    if (isNewReceiptItem) {
      final double subtotal = itemEntity.includeTax == 1
          ? (itemEntity.price * quantity * (100 / (100 + itemEntity.taxRate)))
          : itemEntity.price * quantity;
      final double taxAmount = itemEntity.includeTax == 1
          ? (itemEntity.price * quantity) - subtotal
          : itemEntity.price * quantity * (itemEntity.taxRate / 100);
      newReceiptItems.add(ReceiptItemEntity(
        quantity: quantity,
        subtotal: subtotal,
        itemEntity: itemEntity,
        id: null,
        taxAmount: taxAmount,
      ));
      totalPrice += subtotal;
      totalTax += taxAmount;
    }

    final ReceiptEntity newState = state.copyWith(
      receiptItems: newReceiptItems,
      totalPrice: totalPrice,
      totalTax: totalTax,
    );
    emit(newState);
  }

  void addOrUpdateReceiptLoopBlock(
      ItemEntity itemEntity, String itemBarcode, double quantity) {
    List<ReceiptItemEntity> newReceiptItems = [];
    double totalPrice = 0;
    double totalTax = 0;
    bool isNewReceiptItem = true;
    for (final currentReceiptItem in state.receiptItems) {
      if (currentReceiptItem.itemEntity.barcode == itemBarcode) {
        currentReceiptItem.quantity += quantity;
        currentReceiptItem.subtotal = itemEntity.includeTax == 1
            ? (itemEntity.price *
                currentReceiptItem.quantity *
                (100 / (100 + itemEntity.taxRate)))
            : itemEntity.price * currentReceiptItem.quantity;
        currentReceiptItem.taxAmount = itemEntity.includeTax == 1
            ? (itemEntity.price * currentReceiptItem.quantity) -
                currentReceiptItem.subtotal
            : itemEntity.price *
                currentReceiptItem.quantity *
                (itemEntity.taxRate / 100);
        isNewReceiptItem = false;
        newReceiptItems.add(currentReceiptItem);
      } else {
        newReceiptItems.add(currentReceiptItem);
      }
      totalPrice += currentReceiptItem.subtotal;
      totalTax += currentReceiptItem.taxAmount;
    }

    if (isNewReceiptItem) {
      final double subtotal = itemEntity.includeTax == 1
          ? (itemEntity.price * quantity * (100 / (100 + itemEntity.taxRate)))
          : itemEntity.price * quantity;
      final double taxAmount = itemEntity.includeTax == 1
          ? (itemEntity.price * quantity) - subtotal
          : itemEntity.price * quantity * (itemEntity.taxRate / 100);
      newReceiptItems.add(ReceiptItemEntity(
        quantity: quantity,
        subtotal: subtotal,
        itemEntity: itemEntity,
        id: null,
        taxAmount: taxAmount,
      ));
      totalPrice += subtotal;
      totalTax += taxAmount;
    }

    final ReceiptEntity newState = state.copyWith(
      receiptItems: newReceiptItems,
      totalPrice: totalPrice,
      totalTax: totalTax,
    );
    emit(newState);
  }

  void updateQuantity(ReceiptItemEntity receiptItemEntity, double quantity) {
    List<ReceiptItemEntity> newReceiptItems = [];
    double totalPrice = 0;

    for (final currentReceiptItem in state.receiptItems) {
      if (currentReceiptItem.itemEntity.barcode ==
          receiptItemEntity.itemEntity.barcode) {
        currentReceiptItem.quantity += quantity;
        currentReceiptItem.subtotal =
            (currentReceiptItem.quantity * receiptItemEntity.itemEntity.price);
        newReceiptItems.add(currentReceiptItem);
      } else {
        newReceiptItems.add(currentReceiptItem);
      }
      totalPrice += currentReceiptItem.subtotal;
    }

    final ReceiptEntity newState =
        state.copyWith(receiptItems: newReceiptItems, totalPrice: totalPrice);
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

    // addOrUpdateReceiptLoopBlock(
    //   priceSetItemEntity,
    //   itemEntity.barcode,
    //   quantity,
    // );

    List<ReceiptItemEntity> newReceiptItems = [];
    double totalPrice = 0;
    double totalTax = 0;
    bool isNewReceiptItem = true;
    for (final currentReceiptItem in state.receiptItems) {
      if (currentReceiptItem.itemEntity.barcode == priceSetItemEntity.barcode &&
          currentReceiptItem.itemEntity.price == priceSetItemEntity.price) {
        currentReceiptItem.quantity += quantity;
        currentReceiptItem.subtotal = priceSetItemEntity.includeTax == 1
            ? (priceSetItemEntity.price *
                currentReceiptItem.quantity *
                (100 / (100 + priceSetItemEntity.taxRate)))
            : priceSetItemEntity.price * currentReceiptItem.quantity;
        currentReceiptItem.taxAmount = priceSetItemEntity.includeTax == 1
            ? (priceSetItemEntity.price * currentReceiptItem.quantity) -
                currentReceiptItem.subtotal
            : priceSetItemEntity.price *
                currentReceiptItem.quantity *
                (priceSetItemEntity.taxRate / 100);
        isNewReceiptItem = false;
        newReceiptItems.add(currentReceiptItem);
      } else {
        newReceiptItems.add(currentReceiptItem);
      }
      totalPrice += currentReceiptItem.subtotal;
      totalTax += currentReceiptItem.taxAmount;
    }

    if (isNewReceiptItem) {
      final double subtotal = priceSetItemEntity.includeTax == 1
          ? (priceSetItemEntity.price *
              quantity *
              (100 / (100 + priceSetItemEntity.taxRate)))
          : priceSetItemEntity.price * quantity;
      final double taxAmount = priceSetItemEntity.includeTax == 1
          ? (priceSetItemEntity.price * quantity) - subtotal
          : priceSetItemEntity.price *
              quantity *
              (priceSetItemEntity.taxRate / 100);
      newReceiptItems.add(ReceiptItemEntity(
        quantity: quantity,
        subtotal: subtotal,
        itemEntity: priceSetItemEntity,
        id: null,
        taxAmount: taxAmount,
      ));
      totalPrice += subtotal;
      totalTax += taxAmount;
    }

    final ReceiptEntity newState = state.copyWith(
      receiptItems: newReceiptItems,
      totalPrice: totalPrice,
      totalTax: totalTax,
    );
    emit(newState);
  }

  void clearReceiptItems() {
    emit(state.copyWith(
        receiptItems: [],
        totalPrice: 0,
        totalTax: 0,
        docNum:
            "S0001-${DateFormat('yyMMdd').format(DateTime.now())}${Random().nextInt(999) + 1000}/INV1"));
  }

  void updateMopSelection(
      {required MopSelectionEntity mopSelectionEntity,
      required double amountReceived}) {
    final newState = state.copyWith(
        mopSelection: mopSelectionEntity, amountReceived: amountReceived);
    emit(newState);
  }

  void updateCustomer(CustomerEntity customerEntity) {
    emit(state.copyWith(customerEntity: customerEntity));
  }

  void removeReceiptItem() {}

  void resetReceipt() {
    emit(ReceiptEntity(
        docNum:
            "S0001-${DateFormat('yyMMdd').format(DateTime.now())}${Random().nextInt(999) + 1000}/INV1",
        receiptItems: [],
        totalPrice: 0,
        totalTax: 0));
  }

  void saveReceipt() async {
    return await _saveReceiptUseCase(params: state);
  }
}
