// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer' as dev;
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/resources/loop_tracker.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/invoice_service.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/sales/domain/entities/approval_invoice.dart';
import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/invoice_header.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_header.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_promo_toprn.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_rounding.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_buy_x_get_y_applicability.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/delete_queued_receipt_by_docId.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_cash_register.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_employee.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_by_barcode.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_with_and_condition.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_open_price.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_buy_x_get_y.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_special_price.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_topdg.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_topdi.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_without_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/open_cash_drawer.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/queue_receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_receipt_by_new_receipt_items.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_tax.dart';
import 'package:pos_fe/features/sales/domain/usecases/save_receipt.dart';
import 'package:pos_fe/features/sales/presentation/widgets/confirm_reset_promo_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/open_price_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/promo_get_y_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final HandlePromoTopdgUseCase _handlePromoTopdgUseCase;
  final HandlePromoTopdiUseCase _handlePromoTopdiUseCase;
  final ApplyPromoToprnUseCase _applyPromoToprnUseCase;
  final GetPosParameterUseCase _getPosParameterUseCase;
  final GetStoreMasterUseCase _getStoreMasterUseCase;
  final GetCashRegisterUseCase _getCashRegisterUseCase;
  final ApplyRoundingUseCase _applyRoundingUseCase;
  final GetItemWithAndConditionUseCase _getItemWithAndConditionUseCase;

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
    this._handlePromoTopdgUseCase,
    this._handlePromoTopdiUseCase,
    this._applyPromoToprnUseCase,
    this._getPosParameterUseCase,
    this._getStoreMasterUseCase,
    this._getCashRegisterUseCase,
    this._applyRoundingUseCase,
    this._getItemWithAndConditionUseCase,
  ) : super(ReceiptEntity(
            docNum: "-",
            receiptItems: [],
            subtotal: 0,
            totalTax: 0,
            transStart: DateTime.now(),
            taxAmount: 0,
            grandTotal: 0,
            vouchers: [],
            promos: []));

  Future<void> addUpdateReceiptItems(AddUpdateReceiptItemsParams params) async {
    try {
      // Validate params
      if (params.context == null) {
        throw "Params invalid";
      }
      if (params.barcode == null && params.itemEntity == null) {
        throw "Item barcode or item required";
      }

      // Check qty
      if (params.quantity == 0) {
        throw "Quantity cannot be 0";
      }

      // Initialize some values
      if (state.receiptItems.isEmpty && state.customerEntity?.custCode == "99") {
        await resetReceipt();
      }

      // Declare variables
      ItemEntity? itemEntity;
      ReceiptItemEntity receiptItemEntity;
      final List<PromotionsEntity?> availablePromos;

      // Handle negative quantity
      final ReceiptItemEntity? currentReceiptItemEntity = state.receiptItems
          .where((e) => e.itemEntity.barcode == (params.barcode ?? params.itemEntity!.barcode))
          .firstOrNull;
      if (currentReceiptItemEntity != null) {
        if (currentReceiptItemEntity.quantity + params.quantity == 0) {
          await removeReceiptItem(currentReceiptItemEntity, params.context!);
          return;
        } else if (params.quantity < 0 && currentReceiptItemEntity.quantity > 0) {
          await removeReceiptItem(currentReceiptItemEntity, params.context!);
          await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
            barcode: params.barcode,
            itemEntity: params.itemEntity,
            quantity: currentReceiptItemEntity.quantity + params.quantity,
            context: params.context,
            onOpenPriceInputted: params.onOpenPriceInputted,
            remarks: params.remarks,
            tohemId: params.tohemId,
          ));
          return;
        }
      }

      // Handle reset promo
      if (state.previousReceiptEntity != null) {
        final bool? isProceed = await showDialog<bool>(
          context: params.context!,
          barrierDismissible: false,
          builder: (context) => const ConfirmResetPromoDialog(),
        );
        // dev.log("isProceed $isProceed");
        if (isProceed == null) return;
        if (!isProceed) return;
      }
      ReceiptEntity newReceipt = state.previousReceiptEntity ?? state;

      // Get item entity and validate

      // if (params.barcode != null) {
      // itemEntity = await _getItemByBarcodeUseCase.call(params: params.barcode);
      if (state.customerEntity?.toplnId != null) {
        itemEntity = await _getItemWithAndConditionUseCase.call(params: {
          ItemFields.barcode: params.barcode ?? params.itemEntity?.barcode,
          ItemFields.toplnId: state.customerEntity!.toplnId
        });
      }
      if (itemEntity == null) {
        final POSParameterEntity? posParameterEntity = await _getPosParameterUseCase.call();
        if (posParameterEntity?.tostrId == null) "Invalid POS Parameter: Store Master ID not found";
        final StoreMasterEntity? storeMasterEntity =
            await _getStoreMasterUseCase.call(params: posParameterEntity!.tostrId);
        if (storeMasterEntity?.toplnId == null) "Invalid Store Master: Pricelist ID not found";
        itemEntity = await _getItemWithAndConditionUseCase.call(params: {
          ItemFields.barcode: params.barcode ?? params.itemEntity?.barcode,
          ItemFields.toplnId: storeMasterEntity!.toplnId
        });
      }
      // } else {
      //   itemEntity = params.itemEntity;
      // }
      if (itemEntity == null) throw "Item not found";

      // Convert item entity to receipt item entity **qty conversion can be placed here**
      receiptItemEntity = ReceiptHelper.convertItemEntityToReceiptItemEntity(itemEntity, params.quantity)
        ..tohemId = params.tohemId
        ..remarks = params.remarks;

      // Handle open price
      if (receiptItemEntity.itemEntity.openPrice == 1) {
        final List<ReceiptItemEntity> existingItem = newReceipt.receiptItems
            .where((element) => element.itemEntity.barcode == receiptItemEntity.itemEntity.barcode)
            .toList();
        final bool isItemExist = existingItem.isNotEmpty;

        if (isItemExist) {
          receiptItemEntity = ReceiptHelper.updateReceiptItemAggregateFields(
              receiptItemEntity.copyWith(quantity: params.quantity, itemEntity: existingItem[0].itemEntity));
        } else {
          final double? newPrice = await showDialog<double>(
            context: params.context!,
            barrierDismissible: false,
            builder: (context) => OpenPriceDialog(receiptItemEntity: receiptItemEntity, quantity: params.quantity),
          );
          params.onOpenPriceInputted();
          if (newPrice == null) throw "Price is required";
          receiptItemEntity = await _handleOpenPriceUseCase(
              params: HandleOpenPriceUseCaseParams(receiptItemEntity: receiptItemEntity, newPrice: newPrice));
        }
      }

      // Handle promos
      // dev.log("item entity toitmid ${receiptItemEntity.itemEntity}");
      availablePromos = await _checkPromoUseCase(params: receiptItemEntity.itemEntity.toitmId);
      bool anyPromoApplied = false;
      if (availablePromos.isNotEmpty) {
        for (final availablePromo in availablePromos) {
          switch (availablePromo!.promoType) {
            case 202:
              // dev.log("CASE 202");
              newReceipt = await _handlePromoSpecialPriceUseCase.call(
                  params: HandlePromosUseCaseParams(
                receiptItemEntity: receiptItemEntity,
                receiptEntity: newReceipt,
                promo: availablePromo,
              ));
              anyPromoApplied = true;
            default:
              break;
          }
        }
      }

      // Handle without promos
      if (!anyPromoApplied) {
        newReceipt = await _handleWithoutPromosUseCase.call(
            params: HandlePromosUseCaseParams(receiptItemEntity: receiptItemEntity, receiptEntity: newReceipt));
      }

      // Recalculate receipt
      newReceipt = await _recalculateReceiptUseCase.call(params: newReceipt);

      // dev.log("Result addUpdate ${newReceipt.copyWith(previousReceiptEntity: null)}");

      emit(newReceipt.copyWith(previousReceiptEntity: null));
    } catch (e, s) {
      dev.log(s.toString());
      rethrow;
    }
  }

  void updateMopSelection({required List<MopSelectionEntity> mopSelectionEntities}) {
    final newState = state.copyWith(
        mopSelections: mopSelectionEntities,
        totalPayment: mopSelectionEntities.isEmpty
            ? state.totalVoucher?.toDouble() ?? 0
            : (mopSelectionEntities.map((e) => e.amount).reduce((value, element) => (value ?? 0) + (element ?? 0)) ??
                    0) +
                (state.totalVoucher ?? 0),
        totalNonVoucher: mopSelectionEntities.isEmpty
            ? 0
            : mopSelectionEntities.map((e) => e.amount).reduce((value, element) => (value ?? 0) + (element ?? 0)),
        previousReceiptEntity: state.previousReceiptEntity);
    emit(newState);
  }

  void updateVouchersSelection({
    required List<VouchersSelectionEntity> vouchersSelectionEntity,
    required int vouchersAmount,
  }) {
    final newState = state.copyWith(
      vouchers: vouchersSelectionEntity,
      totalVoucher: vouchersAmount,
      totalPayment: (state.totalNonVoucher ?? 0) + vouchersAmount,
      previousReceiptEntity: state.previousReceiptEntity,
    );

    emit(newState);
  }

  Future<void> updateTohemIdRemarksOnReceiptItem(String tohemId, String remarks, int index) async {
    final newReceiptItem = state.receiptItems[index].copyWith(
      remarks: remarks,
      tohemId: tohemId,
    );
    final newReceiptItems = List<ReceiptItemEntity>.from(state.receiptItems);
    newReceiptItems[index] = newReceiptItem;

    final newState = state.copyWith(
      receiptItems: newReceiptItems,
    );
    emit(newState);
  }

  Future<void> updateSalesTohemIdRemarksOnReceipt(String tohemId, String remarks) async {
    final newState = state.copyWith(
      remarks: remarks,
      salesTohemId: tohemId,
    );
    dev.log("newState - $newState");
    emit(newState);
  }

  Future<void> updateCustomer(CustomerEntity customerEntity, BuildContext context) async {
    if (state.customerEntity?.docId == customerEntity.docId) return;

    if (state.previousReceiptEntity != null && state.customerEntity?.docId != customerEntity.docId) {
      final bool? isProceed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const ConfirmResetPromoDialog(),
      );
      if (isProceed == null) return;
      if (!isProceed) return;

      final List<ReceiptItemEntity> receiptItems =
          state.previousReceiptEntity!.receiptItems.map((e) => e.copyWith()).toList();
      await resetReceipt();
      emit(state.copyWith(customerEntity: customerEntity));
      for (final receiptItem in receiptItems) {
        await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
          barcode: receiptItem.itemEntity.barcode,
          itemEntity: null,
          quantity: receiptItem.quantity,
          context: context,
          onOpenPriceInputted: () => receiptItem.itemEntity.price,
          remarks: receiptItem.remarks,
          tohemId: receiptItem.tohemId,
        ));
      }
      return emit(state.copyWith(customerEntity: customerEntity));
    }

    // final bool? isProceed = await showDialog<bool>(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => const ConfirmResetPromoDialog(),
    // );
    // if (isProceed == null) return;
    // if (!isProceed) return;

    final List<ReceiptItemEntity> receiptItems = state.receiptItems.map((e) => e.copyWith()).toList();
    await resetReceipt();
    emit(state.copyWith(customerEntity: customerEntity));

    for (final receiptItem in receiptItems) {
      await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
        barcode: receiptItem.itemEntity.barcode,
        itemEntity: null,
        quantity: receiptItem.quantity,
        context: context,
        onOpenPriceInputted: () => receiptItem.itemEntity.price,
        remarks: receiptItem.remarks,
        tohemId: receiptItem.tohemId,
      ));
    }
    emit(state.copyWith(customerEntity: customerEntity, previousReceiptEntity: state.previousReceiptEntity));
  }

  Future<void> updateEmployee(EmployeeEntity employeeEntity, BuildContext context) async {
    if (state.previousReceiptEntity != null && state.employeeEntity?.docId != employeeEntity.docId) {
      final bool? isProceed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const ConfirmResetPromoDialog(),
      );
      if (isProceed == null) return;
      if (!isProceed) return;

      return emit(state.previousReceiptEntity!.copyWith(employeeEntity: employeeEntity));
    }
    emit(state.copyWith(employeeEntity: employeeEntity, previousReceiptEntity: state.previousReceiptEntity));
  }

  Future<void> updateApprovals(ApprovalInvoiceEntity approvalsEntity) async {
    final approvalsMap = <String, ApprovalInvoiceEntity>{};

    if (state.approvals != null) {
      for (var approval in state.approvals!) {
        approvalsMap[approval.toinvId!] = approval;
      }
    }

    if (approvalsMap.containsKey(approvalsEntity.toinvId)) {
      bool categoryExists = false;
      for (var approval in approvalsMap.values) {
        if (approval.toinvId == approvalsEntity.toinvId && approval.category == approvalsEntity.category) {
          // Update the approval with the same category
          approvalsMap[approvalsEntity.toinvId!] = approvalsEntity;
          categoryExists = true;
          break;
        }
      }
      // If the category is different, add the new approval
      if (!categoryExists) {
        approvalsMap[approvalsEntity.docId] = approvalsEntity;
      }
    } else {
      // Add the approval if toinvId does not exist
      approvalsMap[approvalsEntity.docId] = approvalsEntity;
    }

    final newState = state.copyWith(
      approvals: approvalsMap.values.toList(),
    );

    dev.log("updateApp newState - ${newState.approvals}");
    emit(newState);
  }

  Future<void> updateCoupons(List<PromoCouponHeaderEntity> couponsEntity) async {
    List<PromoCouponHeaderEntity> appliedCoupons = [];
    int? promo;
    appliedCoupons = couponsEntity;

    for (var coupon in appliedCoupons) {
      if (coupon.includePromo == 1) {
        promo = 1;
      } else {
        promo = 0;
      }
    }

    return emit(state.copyWith(coupons: appliedCoupons, includePromo: promo));
  }

  Future<void> removeReceiptItem(ReceiptItemEntity receiptItemEntity, BuildContext context) async {
    List<ReceiptItemEntity> newReceiptItems = [];

    if (state.previousReceiptEntity != null) {
      final bool? isProceed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const ConfirmResetPromoDialog(),
      );
      if (isProceed == null) return;
      if (!isProceed) return;
    }

    final ReceiptEntity receiptEntity = state.previousReceiptEntity ?? state;

    for (final currentReceiptItem in receiptEntity.receiptItems.map((e) => e.copyWith())) {
      if (receiptItemEntity.itemEntity.barcode != currentReceiptItem.itemEntity.barcode) {
        newReceiptItems.add(currentReceiptItem);
      }
    }

    final ReceiptEntity newState = await _recalculateReceiptUseCase.call(
        params: receiptEntity.copyWith(
      receiptItems: newReceiptItems,
    ));

    // dev.log("Remove Item $newState");

    emit(newState);
  }

  Future<void> charge() async {
    try {
      ReceiptEntity? newState;
      if (state.totalVoucher! >= state.grandTotal && state.grandTotal != 0) {
        newState = state.copyWith(
          mopSelections: [],
          changed: 0,
          totalNonVoucher: 0,
        );
      } else {
        newState = state.copyWith(changed: state.totalPayment! - state.grandTotal);
      }

      // dev.log("ON CHARGE - $newState");
      final ReceiptEntity? createdReceipt = await _saveReceiptUseCase.call(params: newState);

      if (createdReceipt != null) {
        if (state.toinvId != null) {
          await _deleteQueuedReceiptUseCase.call(params: state.toinvId);
        }
        if (newState.queuedInvoiceHeaderDocId != null) {
          await GetIt.instance<AppDatabase>()
              .queuedInvoiceHeaderDao
              .deleteByDocId(newState.queuedInvoiceHeaderDocId!, null);
        }
        emit(createdReceipt);
        // dev.log("createdReceipt onCharge $createdReceipt");
        try {
          await _printReceiptUsecase.call(
              params: PrintReceiptUseCaseParams(receiptEntity: createdReceipt, printType: 1));
          await _openCashDrawerUseCase.call();
        } catch (e) {
          dev.log(e.toString());
        }
        try {
          GetIt.instance<InvoiceApi>().sendInvoice();
        } catch (e) {
          return;
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetReceipt() async {
    try {
      final DateTime now = DateTime.now();
      final EmployeeEntity? employeeEntity = await _getEmployeeUseCase.call();
      final CustomerEntity? customerEntity = await GetIt.instance<AppDatabase>().customerDao.readByCustCode("99", null);
      final List<InvoiceHeaderEntity> invoiceHeaderEntities =
          await GetIt.instance<AppDatabase>().invoiceHeaderDao.readByShiftAndDatetime(now);
      final POSParameterEntity? posParameterEntity = await _getPosParameterUseCase.call();
      if (posParameterEntity == null) throw "POS Parameter not found";
      final StoreMasterEntity? storeMasterEntity =
          await _getStoreMasterUseCase.call(params: posParameterEntity.tostrId);
      if (storeMasterEntity == null) throw "Store master not found";
      final CashRegisterEntity? cashRegisterEntity =
          await _getCashRegisterUseCase.call(params: posParameterEntity.tocsrId!);
      if (cashRegisterEntity == null) throw "Cash register not found";

      emit(ReceiptEntity(
        docNum:
            "${storeMasterEntity.storeCode}-${DateFormat('yyMMddHHmmss').format(now)}${ReceiptHelper.convertIntegerToTwoDigitString(invoiceHeaderEntities.length + 1)}/${ReceiptHelper.convertIntegerToThreeDigitString(int.parse(cashRegisterEntity.idKassa!))}",
        employeeEntity: employeeEntity,
        customerEntity: customerEntity,
        receiptItems: [],
        subtotal: 0,
        totalTax: 0,
        transStart: DateTime.now(),
        taxAmount: 0,
        grandTotal: 0,
        vouchers: [],
        promos: [],
      ));
    } catch (e) {
      rethrow;
    }
  }

  void queueReceipt() async {
    if (state.queuedInvoiceHeaderDocId != null) {
      await GetIt.instance<AppDatabase>().queuedInvoiceHeaderDao.deleteByDocId(state.queuedInvoiceHeaderDocId!, null);
    }
    log("queueReceiptCubit - $state");
    await _queueReceiptUseCase.call(params: state.previousReceiptEntity ?? state);
    resetReceipt();
  }

  void retrieveFromQueue(ReceiptEntity receiptEntity, BuildContext context) async {
    dev.log("retrieveFromQueue - $receiptEntity");
    await resetReceipt();

    for (final receiptItem in receiptEntity.receiptItems) {
      await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
        barcode: receiptItem.itemEntity.barcode,
        itemEntity: null,
        quantity: receiptItem.quantity,
        context: context,
        onOpenPriceInputted: () => receiptItem.itemEntity.price,
        remarks: receiptItem.remarks,
        tohemId: receiptItem.tohemId,
      ));
    }

    dev.log("Retrievefromqueue $state");

    emit(state
      ..queuedInvoiceHeaderDocId = receiptEntity.queuedInvoiceHeaderDocId
      ..customerEntity = receiptEntity.customerEntity
      ..salesTohemId = receiptEntity.salesTohemId
      ..remarks = receiptEntity.remarks);
  }

  Future<void> updateTotalAmountFromDiscount(double discValue) async {
    try {
      if (discValue > state.grandTotal + (state.discHeaderManual ?? 0)) {
        throw "Discount amount invalid";
      }

      ReceiptEntity preparedReceipt = state;

      if ((state.discHeaderManual ?? 0) > 0) {
        preparedReceipt = await _recalculateReceiptUseCase.call(
            params: state.copyWith(
          discHeaderManual: 0,
          discAmount: (state.discHeaderPromo ?? 0),
        ));
      }

      final ReceiptEntity newState = preparedReceipt.copyWith(
        discHeaderManual: discValue,
        // discAmount: discValue + (state.discHeaderPromo ?? 0),
      );

      ReceiptEntity updatedReceipt = await _recalculateTaxUseCase.call(params: newState);
      updatedReceipt = await _applyRoundingUseCase.call(params: updatedReceipt);
      // dev.log("Result updateTotalAmountFromDiscount - $updatedReceipt");

      emit(updatedReceipt.copyWith(
          previousReceiptEntity: state.previousReceiptEntity ?? state.copyWith(previousReceiptEntity: null)));
    } catch (e) {
      dev.log("Error during tax recalculation: $e");
      rethrow;
    }
  }

  Future<void> processReceiptBeforeCheckout(BuildContext context) async {
    try {
      ReceiptItemEntity? dpItem = state.receiptItems.where((element) => element.itemEntity.barcode == "99").firstOrNull;
      List<ReceiptItemEntity> normalItems =
          state.receiptItems.where((element) => element.itemEntity.barcode != "99").toList();
      ReceiptEntity newReceipt = state.copyWith(
        receiptItems: normalItems.map((e) => e.copyWith()).toList(),
        previousReceiptEntity: state.previousReceiptEntity,

        // Reset MOP related fields
        vouchers: [],
        totalPayment: 0,
        changed: 0,
        totalVoucher: 0,
        totalNonVoucher: 0,
      )..mopSelections = [];
      List<String> skippedPromoIds = [];

      // dev.log("First entry $newReceipt");

      final double discHeaderManual = state.discHeaderManual ?? 0;

      if (discHeaderManual > 0 || dpItem != null) {
        newReceipt = await _recalculateReceiptUseCase.call(
            params: newReceipt.copyWith(
          discHeaderManual: 0,
          discAmount: (newReceipt.discHeaderPromo ?? 0),
        ));
      }

      // dev.log("Process before checkout $newReceipt");

      // ini artinya barang dari buy x get ga discan ulang
      for (final receiptItem in state.copyWith().receiptItems) {
        List<PromotionsEntity?> availablePromos = [];
        availablePromos = await _checkPromoUseCase(params: receiptItem.itemEntity.toitmId);
        // dev.log("available promos $availablePromos");

        if (availablePromos.isNotEmpty) {
          for (final availablePromo in availablePromos) {
            if (skippedPromoIds.contains(availablePromo!.promoId)) continue;
            switch (availablePromo.promoType) {
              case 103:
                dev.log("103 checked");
                // Check applicability
                final CheckBuyXGetYApplicabilityResult checkBuyXGetYApplicability =
                    await _checkBuyXGetYApplicabilityUseCase.call(
                        params: CheckBuyXGetYApplicabilityParams(
                  receiptEntity: newReceipt,
                  receiptItemEntity: receiptItem,
                  promo: availablePromo,
                ));

                if (!checkBuyXGetYApplicability.isApplicable) break;

                // Show Pop Up
                List<PromoBuyXGetYGetConditionAndItemEntity> selectedConditionAndItemYs = [];
                for (int i = 0; i < checkBuyXGetYApplicability.availableApplyCount; i++) {
                  final List<PromoBuyXGetYGetConditionAndItemEntity> selectedConditionAndItemYsPerDialog =
                      (await showDialog<List<PromoBuyXGetYGetConditionAndItemEntity>>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => PromoGetYDialog(
                              conditionAndItemYs: checkBuyXGetYApplicability.conditionAndItemYs,
                              toprb: checkBuyXGetYApplicability.toprb!,
                              loopTracker: LoopTracker(
                                  currentLoop: i + 1, totalLoop: checkBuyXGetYApplicability.availableApplyCount),
                            ),
                          )) ??
                          [];
                  if (selectedConditionAndItemYsPerDialog.isEmpty) break;

                  for (final selectedConditionAndItemYPerDialog in selectedConditionAndItemYsPerDialog) {
                    final List<PromoBuyXGetYGetConditionAndItemEntity> existElements = selectedConditionAndItemYs
                        .where((element) =>
                            element.itemEntity.barcode == selectedConditionAndItemYPerDialog.itemEntity.barcode)
                        .toList();
                    final PromoBuyXGetYGetConditionAndItemEntity? existElement =
                        existElements.isEmpty ? null : existElements.first;
                    if (existElement != null) {
                      existElement.multiply += 1;
                    } else {
                      selectedConditionAndItemYs.add(selectedConditionAndItemYPerDialog..multiply = 1);
                    }
                  }
                }

                if (selectedConditionAndItemYs.isEmpty) {
                  skippedPromoIds.add(availablePromo.promoId!);
                  continue;
                }

                // Handle X Items and Y Items
                newReceipt = await _handlePromoBuyXGetYUseCase.call(
                    params: HandlePromoBuyXGetYUseCaseParams(
                        receiptItemEntity: receiptItem,
                        promo: availablePromo,
                        toprb: checkBuyXGetYApplicability.toprb,
                        receiptEntity: newReceipt,
                        conditionAndItemXs: checkBuyXGetYApplicability.conditionAndItemXs,
                        existingReceiptItemXs: checkBuyXGetYApplicability.existingReceiptItemXs,
                        conditionAndItemYs: selectedConditionAndItemYs));
                newReceipt = await _recalculateReceiptUseCase.call(params: newReceipt);
                break;
              case 203:
                dev.log("CASE 203");
                newReceipt = await _handlePromoTopdiUseCase.call(
                    params: HandlePromosUseCaseParams(
                  receiptItemEntity: receiptItem,
                  receiptEntity: newReceipt,
                  promo: availablePromo,
                ));

              case 204:
                newReceipt = await _handlePromoTopdgUseCase.call(
                    params: HandlePromosUseCaseParams(
                  receiptItemEntity: receiptItem,
                  receiptEntity: newReceipt,
                  promo: availablePromo,
                ));
              default:
                break;
            }
          }
        }
      }

      final couponsApplied = state.copyWith().coupons;
      final SharedPreferences prefs = GetIt.instance<SharedPreferences>();
      final check = prefs.getBool('isSyncing');
      dev.log("check - $check");
      if (couponsApplied != null) {
        newReceipt = await _applyPromoToprnUseCase.call(params: newReceipt);
      }

      dev.log("newReceiptCoupon - $newReceipt");

      // dev.log("Process after checkout $newReceipt");

      if (dpItem != null && dpItem.quantity < 0) {
        if (dpItem.sellingPrice > newReceipt.grandTotal) {
          throw "Down payment exceeds grand total (overpayment: ${Helpers.parseMoney(dpItem.sellingPrice - newReceipt.grandTotal)})";
        } else {
          newReceipt = await _recalculateReceiptUseCase.call(
              params: newReceipt.copyWith(
            receiptItems: newReceipt.receiptItems.map((e) => e.copyWith()).toList() + [dpItem.copyWith()],
          ));
        }
      } else if (dpItem != null && dpItem.quantity > 0) {
        newReceipt = await _recalculateReceiptUseCase.call(
            params: newReceipt.copyWith(
          receiptItems: [dpItem.copyWith()],
        ));
      }

      if (discHeaderManual > 0 && newReceipt.grandTotal + (dpItem?.sellingPrice ?? 0) >= discHeaderManual) {
        newReceipt = await _recalculateTaxUseCase.call(
            params: newReceipt.copyWith(
          discHeaderManual: discHeaderManual,
          // discAmount: discHeaderManual + (newReceipt.discHeaderPromo ?? 0),
          // discPrctg: (100 * (discHeaderManual + (newReceipt.discHeaderPromo ?? 0))) / newReceipt.subtotal,
        ));
      }

      // dev.log("Process reapply discount header $newReceipt");

      newReceipt = await _applyRoundingUseCase.call(params: newReceipt);

      // dev.log("To emit ${newReceipt.copyWith(
      //   previousReceiptEntity: state.copyWith(
      //       receiptItems: state.receiptItems.map((e) => e.copyWith()).toList(), previousReceiptEntity: null),
      // )}");

      // dev.log("previousreceipt before emit ${state.previousReceiptEntity}");
      dev.log("newReceiptLast - $newReceipt");
      emit(newReceipt.copyWith(
        previousReceiptEntity: state.previousReceiptEntity ??
            state.copyWith(
                receiptItems: state.receiptItems.map((e) => e.copyWith()).toList(), previousReceiptEntity: null),
      ));

      // dev.log("after emit $state");
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetMopAndVoucher() async {
    emit(
      state.copyWith(
        previousReceiptEntity: state.previousReceiptEntity,
        vouchers: [],
        totalPayment: 0,
        changed: 0,
        totalVoucher: 0,
        totalNonVoucher: 0,
      )..mopSelections = [],
    );
    return;
  }

  Future<void> resetMop() async {
    emit(
      state.copyWith(
        previousReceiptEntity: state.previousReceiptEntity,
        totalPayment: state.totalVoucher?.toDouble() ?? 0,
        changed: 0,
        totalNonVoucher: 0,
      )..mopSelections = [],
    );
    return;
  }
}

class AddUpdateReceiptItemsParams {
  final String? barcode;
  final ItemEntity? itemEntity;
  final double quantity;
  final BuildContext? context;
  final void Function() onOpenPriceInputted;
  final String? remarks;
  final String? tohemId;

  AddUpdateReceiptItemsParams({
    required this.barcode,
    required this.itemEntity,
    required this.quantity,
    required this.context,
    required this.onOpenPriceInputted,
    this.remarks,
    this.tohemId,
  });
}
