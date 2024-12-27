// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/resources/loop_tracker.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/invoice_service.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/sales/data/models/promo_spesial_multi_item_detail.dart';
import 'package:pos_fe/features/sales/domain/entities/approval_invoice.dart';
import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/down_payment_entity.dart';
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
import 'package:pos_fe/features/sales/domain/usecases/apply_manual_rounding.dart';
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
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_topsm.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_without_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/open_cash_drawer.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/queue_receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_receipt_by_new_receipt_items.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_tax.dart';
import 'package:pos_fe/features/sales/domain/usecases/save_receipt.dart';
import 'package:pos_fe/features/sales/presentation/widgets/confirm_reset_promo_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/discount_and_rounding_dialog.dart';
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
  final HandlePromoTopdgUseCase _handlePromoTopdgUseCase;
  final HandlePromoTopdiUseCase _handlePromoTopdiUseCase;
  // final ApplyPromoToprnUseCase _applyPromoToprnUseCase;
  final GetPosParameterUseCase _getPosParameterUseCase;
  final GetStoreMasterUseCase _getStoreMasterUseCase;
  final GetCashRegisterUseCase _getCashRegisterUseCase;
  final ApplyRoundingUseCase _applyRoundingUseCase;
  final GetItemWithAndConditionUseCase _getItemWithAndConditionUseCase;
  final ApplyPromoToprnUseCase _applyPromoToprnUseCase;
  final ApplyManualRoundingUseCase _applyManualRoundingDownUseCase;
  final ApplyManualRoundingUseCase _applyManualRoundingUpUseCase;
  final HandlePromoSpesialMultiItemUseCase _handlePromoSpesialMultiItemUseCase;

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
    this._getPosParameterUseCase,
    this._getStoreMasterUseCase,
    this._getCashRegisterUseCase,
    this._applyRoundingUseCase,
    this._getItemWithAndConditionUseCase,
    this._applyPromoToprnUseCase,
    this._applyManualRoundingDownUseCase,
    this._applyManualRoundingUpUseCase,
    this._handlePromoSpesialMultiItemUseCase,
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

  void replaceState(ReceiptEntity newReceipt) {
    emit(newReceipt);
  }

  Future<void> addUpdateReceiptItems(AddUpdateReceiptItemsParams params) async {
    try {
      // dev.log("state b4 - ${state.previousReceiptEntity}");
      // Validate params
      if (params.context == null) {
        throw "Params invalid";
      }
      if (params.barcode == null && params.itemEntity == null) {
        throw "Item barcode or item required";
      }
      if (params.quantity == 0) {
        throw "Quantity cannot be 0";
      }
      if (params.refpos3 != null && params.itemEntity == null) {
        throw "An internal error has occured (Return Item requires Item Entity)";
      }

      // Initialize some values
      if (state.receiptItems.isEmpty && state.customerEntity?.custCode == "99" && state.includePromo == null) {
        await resetReceipt();
      }

      // Declare variables
      ItemEntity? itemEntity;
      ReceiptItemEntity receiptItemEntity;
      final List<PromotionsEntity?> availablePromos;
      final int includePromo = params.refpos3 != null ? 0 : state.includePromo ?? 1;

      // Handle negative quantity && validate return item
      final ReceiptItemEntity? currentReceiptItemEntity = state.receiptItems
          .where((e) => e.itemEntity.barcode == (params.barcode ?? params.itemEntity!.barcode))
          .firstOrNull;
      if (currentReceiptItemEntity != null) {
        if (currentReceiptItemEntity.refpos3 != null && params.refpos3 == null) {
          throw "Please modify returned items on Return feature";
        } else if (currentReceiptItemEntity.refpos3 == null && params.refpos3 != null) {
          throw "Purchase and Return cannot be combined on the same item";
        }

        if (currentReceiptItemEntity.quantity + params.quantity == 0) {
          await removeReceiptItem(currentReceiptItemEntity, params.context!);
          return;
        } else if (params.quantity < 0 && currentReceiptItemEntity.quantity > 0) {
          if ((params.barcode ?? params.itemEntity!.barcode) == "99" &&
              currentReceiptItemEntity.quantity + params.quantity < -1) throw "Down payment quantity must be -1 or 1";
          if (params.refpos3 == null && currentReceiptItemEntity.quantity + params.quantity <= 0) {
            throw "Resulting quantity must be positive";
          }
          await removeReceiptItem(currentReceiptItemEntity, params.context!);
          await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
            barcode: params.barcode,
            itemEntity: params.itemEntity,
            quantity: currentReceiptItemEntity.quantity + params.quantity,
            context: params.context,
            onOpenPriceInputted: params.onOpenPriceInputted,
            remarks: params.remarks,
            tohemId: params.tohemId,
            setOpenPrice: params.setOpenPrice,
            refpos3: params.refpos3,
            salesTohemId: params.salesTohemId,
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
        dev.log("isProceed $isProceed");
        if (isProceed == null) return;
        if (!isProceed) return;
      }
      ReceiptEntity newReceipt = state.previousReceiptEntity ?? state;

      // Get item entity and validate
      if (params.refpos3 != null) itemEntity = params.itemEntity;
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
      if (itemEntity == null) throw "Item not found";

      // Convert item entity to receipt item entity **qty conversion can be placed here**
      receiptItemEntity = ReceiptHelper.convertItemEntityToReceiptItemEntity(itemEntity, params.quantity)
        ..tohemId = params.tohemId
        ..remarks = params.remarks
        ..tohemId = params.salesTohemId
        ..refpos2 = params.refpos2
        ..refpos3 = params.refpos3;

      // Handle open price
      if (receiptItemEntity.itemEntity.openPrice == 1 && receiptItemEntity.refpos3 == null) {
        final List<ReceiptItemEntity> existingItem = newReceipt.receiptItems
            .where((element) => element.itemEntity.barcode == receiptItemEntity.itemEntity.barcode)
            .toList();
        final bool isItemExist = existingItem.isNotEmpty;

        if (isItemExist) {
          receiptItemEntity = ReceiptHelper.updateReceiptItemAggregateFields(
              receiptItemEntity.copyWith(quantity: params.quantity, itemEntity: existingItem[0].itemEntity));
        } else {
          final double? newPrice = params.setOpenPrice ??
              await showDialog<double>(
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

      // // Handle overriding price (return)
      // if (params.refpos3 != null) {
      //   receiptItemEntity = ReceiptHelper.updateReceiptItemAggregateFields(receiptItemEntity.copyWith(
      //   itemEntity: receiptItemEntity.itemEntity.copyWith(
      //       price: params.overridingPrice,
      //       dpp: receiptItemEntity.itemEntity.includeTax == 1
      //           ? newPrice * (100 / (100 + receiptItemEntity.itemEntity.taxRate))
      //           : newPrice),
      //   sellingPrice: newPrice,
      // ))
      // }

      // Handle promos
      bool anyPromoApplied = false;
      if (receiptItemEntity.itemEntity.barcode != "99" && includePromo == 1) {
        availablePromos = await _checkPromoUseCase(params: receiptItemEntity.itemEntity.toitmId);
        if (availablePromos.isNotEmpty) {
          for (final availablePromo in availablePromos) {
            final now = DateTime.now();
            final startHour = availablePromo!.startTime.hour;
            final startMinute = availablePromo.startTime.minute;
            final startSecond = availablePromo.startTime.second;
            DateTime startPromo = DateTime(now.year, now.month, now.day, startHour, startMinute, startSecond);
            final endHour = availablePromo.endTime.hour;
            final endMinute = availablePromo.endTime.minute;
            final endSecond = availablePromo.endTime.second;
            DateTime endPromo = DateTime(now.year, now.month, now.day, endHour, endMinute, endSecond);

            final bool isCustomerEligible = newReceipt.customerEntity?.tocrgId == null
                ? false
                : availablePromo.tocrgId == newReceipt.customerEntity?.tocrgId;
            final bool isApplicableNow = now.millisecondsSinceEpoch >= startPromo.millisecondsSinceEpoch &&
                now.millisecondsSinceEpoch <= endPromo.millisecondsSinceEpoch;

            if (!isCustomerEligible || !isApplicableNow) continue;

            switch (availablePromo.promoType) {
              case 202:
                // dev.log("CASE 202");
                try {
                  newReceipt = await _handlePromoSpecialPriceUseCase.call(
                      params: HandlePromosUseCaseParams(
                    receiptItemEntity: receiptItemEntity,
                    receiptEntity: newReceipt,
                    promo: availablePromo,
                  ));
                  anyPromoApplied = true;
                } catch (e) {
                  dev.log(e.toString());
                  SnackBarHelper.presentErrorSnackBar(params.context, e.toString());
                  continue;
                }

              default:
                break;
            }
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

      emit(newReceipt.copyWith(previousReceiptEntity: null, rounding: 0));
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
    emit(newState);
  }

  Future<void> addOrUpdateDownPayments({
    required List<DownPaymentEntity> downPaymentEntities,
    required double amountDifference,
  }) async {
    ReceiptEntity newState = state.copyWith(
      downPayments: downPaymentEntities,
    );

    newState = await _recalculateReceiptUseCase.call(params: newState);
    // dev.log("newState afterAddUpp - $newState");
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
          itemEntity: receiptItem.itemEntity,
          quantity: receiptItem.quantity,
          context: context,
          onOpenPriceInputted: () => receiptItem.itemEntity.price,
          remarks: receiptItem.remarks,
          tohemId: receiptItem.tohemId,
        ));
      }
      return emit(state.copyWith(customerEntity: customerEntity));
    }

    final List<ReceiptItemEntity> receiptItems = state.receiptItems.map((e) => e.copyWith()).toList();
    final salesTohemId = state.salesTohemId ?? "";
    final remarks = state.remarks ?? "";

    await resetReceipt();
    emit(state.copyWith(customerEntity: customerEntity, salesTohemId: salesTohemId, remarks: remarks));

    for (final receiptItem in receiptItems) {
      await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
        barcode: receiptItem.itemEntity.barcode,
        itemEntity: receiptItem.itemEntity,
        quantity: receiptItem.quantity,
        context: context,
        onOpenPriceInputted: () => receiptItem.itemEntity.price,
        remarks: receiptItem.remarks,
        tohemId: receiptItem.tohemId,
        setOpenPrice: receiptItem.itemEntity.price,
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
      previousReceiptEntity: state.previousReceiptEntity,
    );

    dev.log("updateApp newState - ${newState.approvals}");
    emit(newState);
  }

  Future<void> updateCoupons(List<PromoCouponHeaderEntity> couponsEntity, BuildContext context) async {
    List<PromoCouponHeaderEntity> appliedCoupons = [];
    int includePromo = 1;
    appliedCoupons = couponsEntity;
    final ReceiptEntity currentReceipt = state.copyWith();

    for (var coupon in appliedCoupons) {
      if (coupon.includePromo == 0) {
        includePromo = 0;
      }
    }

    if (state.previousReceiptEntity != null && (state.includePromo ?? 1) != includePromo) {
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
      emit(state.copyWith(
        customerEntity: currentReceipt.customerEntity,
        includePromo: includePromo,
        coupons: couponsEntity,
        salesTohemId: currentReceipt.salesTohemId,
        remarks: currentReceipt.remarks,
      ));
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
      return emit(state.copyWith(
        coupons: appliedCoupons,
        includePromo: includePromo,
        customerEntity: currentReceipt.customerEntity,
        salesTohemId: currentReceipt.salesTohemId,
        remarks: currentReceipt.remarks,
      ));
    }

    if ((state.includePromo ?? 1) != includePromo) {
      final List<ReceiptItemEntity> receiptItems = state.receiptItems.map((e) => e.copyWith()).toList();
      await resetReceipt();
      emit(state.copyWith(
        includePromo: includePromo,
        coupons: couponsEntity,
        customerEntity: currentReceipt.customerEntity,
        salesTohemId: currentReceipt.salesTohemId,
        remarks: currentReceipt.remarks,
      ));

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
      return emit(state.copyWith(
          coupons: appliedCoupons,
          includePromo: includePromo,
          customerEntity: currentReceipt.customerEntity,
          salesTohemId: currentReceipt.salesTohemId,
          remarks: currentReceipt.remarks,
          previousReceiptEntity: state.previousReceiptEntity));
    }

    dev.log("Masuk di if 3");
    return emit(state.copyWith(coupons: couponsEntity, includePromo: includePromo));
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
      if (state.totalVoucher! >= state.grandTotal && state.grandTotal > 0) {
        newState = state.copyWith(
          mopSelections: [],
          changed: 0,
          totalNonVoucher: 0,
        );
      } else {
        newState = state.copyWith(changed: state.totalPayment! - state.grandTotal);
      }

      dev.log("ON CHARGE - $newState");
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
          final List<DownPaymentEntity> dpList = newState.downPayments ?? [];

          List<String> dpDocnums = [];
          for (DownPaymentEntity dp in dpList) {
            if (dp.isReceive == false && dp.isSelected == true) {
              dpDocnums.add(dp.refpos2 ?? "");
            }
          }
          GetIt.instance<InvoiceApi>().sendInvoice(dpDocnums, createdReceipt.receiptItems);
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
    await _queueReceiptUseCase.call(params: state.previousReceiptEntity ?? state);
    resetReceipt();
  }

  Future<void> retrieveFromQueue(ReceiptEntity receiptEntity, BuildContext context) async {
    await resetReceipt();

    for (final receiptItem in receiptEntity.receiptItems) {
      await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
        barcode: receiptItem.itemEntity.barcode,
        itemEntity: receiptItem.refpos3 != null ? receiptItem.itemEntity : null,
        quantity: receiptItem.quantity,
        context: context,
        onOpenPriceInputted: () => receiptItem.itemEntity.price,
        remarks: receiptItem.remarks,
        tohemId: receiptItem.tohemId,
        setOpenPrice: receiptItem.sellingPrice,
        refpos3: receiptItem.refpos3,
      ));
    }

    emit(state
      ..queuedInvoiceHeaderDocId = receiptEntity.queuedInvoiceHeaderDocId
      ..customerEntity = receiptEntity.customerEntity
      ..salesTohemId = receiptEntity.salesTohemId
      ..downPayments = receiptEntity.downPayments
      ..remarks = receiptEntity.remarks);
  }

  Future<void> updateTotalAmountFromDiscount(
      double discValue, List<LineDiscountParameter> lineDiscountParameters) async {
    try {
      // dev.log("Before emit discount: $state");

      // Apply line discount
      final List<ReceiptItemEntity> appliedLineDiscReceiptItems = [];
      double totalLineDiscount = 0;
      double totalExistingLineDiscount = state.receiptItems.fold(
          0.0,
          (previousValue, e1) =>
              previousValue +
              (((100 + e1.itemEntity.taxRate) / 100) *
                  e1.promos
                      .where((e2) => e2.promoType == 998)
                      .fold(0.0, (previousValue, e3) => previousValue + (e3.discAmount ?? 0))));
      double newDiscHeaderPromo = 0;

      for (final e in lineDiscountParameters) {
        final double beforeTaxLineDiscount =
            e.lineDiscountAmount * (100 / (100 + e.receiptItemEntity.itemEntity.taxRate));
        final double newDiscAmount = e.receiptItemEntity.promos
                .where((element) => element.promoType != 998)
                .fold(0.0, (previousValue, element) => previousValue + (element.discAmount ?? 0)) +
            beforeTaxLineDiscount;
        final List<PromotionsEntity> newPromos =
            e.receiptItemEntity.promos.where((element) => element.promoType != 998).toList() +
                (beforeTaxLineDiscount != 0
                    ? [
                        PromotionsEntity(
                          docId: "",
                          promoType: 998,
                          date: DateTime.now(),
                          startTime: DateTime.now(),
                          endTime: DateTime.now(),
                          discAmount: beforeTaxLineDiscount,
                          promoDescription: "Line Discount",
                          promoId: "",
                        )
                      ]
                    : []);

        appliedLineDiscReceiptItems.add(ReceiptHelper.updateReceiptItemAggregateFields(e.receiptItemEntity
          ..promos = newPromos
          ..discAmount = newDiscAmount));
        newDiscHeaderPromo += newDiscAmount;
        totalLineDiscount += e.lineDiscountAmount;
      }

      // Copy receipt object
      ReceiptEntity preparedReceipt = state.copyWith(
          grandTotal: state.grandTotal + totalExistingLineDiscount - totalLineDiscount,
          discHeaderPromo: newDiscHeaderPromo,
          discAmount: newDiscHeaderPromo,
          receiptItems: appliedLineDiscReceiptItems.map((e) => e.copyWith()).toList());

      // Adjust when header discount already applied
      if ((state.discHeaderManual ?? 0) > 0) {
        preparedReceipt.grandTotal += state.discHeaderManual!;
        // preparedReceipt.discAmount = preparedReceipt.discHeaderPromo ?? 0;
      }

      // Might be unnecessary
      ReceiptEntity newState = preparedReceipt.copyWith(
        discHeaderManual: discValue,
      );

      // Apply header discount
      ReceiptEntity updatedReceipt = await _recalculateTaxUseCase.call(params: newState);
      updatedReceipt = await _applyRoundingUseCase.call(params: updatedReceipt);

      emit(updatedReceipt.copyWith(previousReceiptEntity: state.previousReceiptEntity));
      // dev.log("After emit discount: $state");
    } catch (e) {
      dev.log("Error during tax recalculation: $e");
      rethrow;
    }
  }

  Future<void> processReceiptBeforeCheckout(BuildContext context) async {
    final ReceiptEntity initialState = state.copyWith(
      receiptItems: state.receiptItems.map((e) => e.copyWith()).toList(),
      previousReceiptEntity: state.previousReceiptEntity?.copyWith(
        receiptItems: state.previousReceiptEntity?.receiptItems.map((e) => e.copyWith()).toList(),
        previousReceiptEntity: null,
      ),

      // Reset MOP related fields
      vouchers: [],
      totalPayment: 0,
      changed: 0,
      totalVoucher: 0,
      totalNonVoucher: 0,
    )..mopSelections = [];
    try {
      // Excludes DP item from calculation
      ReceiptItemEntity? dpItem =
          state.receiptItems.where((element) => element.itemEntity.barcode == "99" && element.quantity > 0).firstOrNull;
      List<ReceiptItemEntity> returnItems = state.receiptItems.where((element) => element.refpos3 != null).toList();
      List<ReceiptItemEntity> normalItems =
          state.receiptItems.where((element) => element.refpos3 == null && element.itemEntity.barcode != "99").toList();

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

      // Reset down payment
      List<DownPaymentEntity> dps = newReceipt.downPayments ?? [];
      double totalDPAmount = dps.fold(0.0, (value, dp) => dp.isSelected == true ? value + dp.amount : value);
      // if (newReceipt.downPayments != null && (newReceipt.downPayments ?? []).isNotEmpty) {
      //   double reset = newReceipt.subtotal + totalDPAmount;
      //   newReceipt = await _recalculateReceiptUseCase.call(params: newReceipt.copyWith(subtotal: reset));
      // }
      // dev.log("resetReceipt - ${newReceipt.subtotal}");

      // Reset manual header discount
      final double discHeaderManual = state.discHeaderManual ?? 0;
      if (discHeaderManual > 0 || dpItem != null) {
        newReceipt = await _recalculateReceiptUseCase.call(
            params: newReceipt.copyWith(
          discHeaderManual: 0,
          discAmount: (newReceipt.discHeaderPromo ?? 0),
        ));
      }

      newReceipt = await _recalculateReceiptUseCase.call(
          params: newReceipt.copyWith(
        receiptItems: newReceipt.receiptItems.map((e) => e.copyWith()).toList(),
      ));

      // Handle promos
      if ((state.includePromo ?? 1) == 1) {
        for (final receiptItem in newReceipt.copyWith().receiptItems.map((e) => e.copyWith())) {
          List<PromotionsEntity?> availablePromos = [];
          availablePromos = await _checkPromoUseCase(params: receiptItem.itemEntity.toitmId);

          if (availablePromos.isNotEmpty) {
            final fillteredPromos = availablePromos.where((element) => element!.promoType == 201);
            List<PromoSpesialMultiItemDetailModel> listTpsm1 = [];
            if (fillteredPromos.length > 1) {
              for (var promo in fillteredPromos) {
                final tpsm1s = await GetIt.instance<AppDatabase>()
                    .promoSpesialMultiItemDetailDao
                    .readAllByTopsmId(promo!.promoId!, null);
                listTpsm1.addAll(tpsm1s.where((element) => element.toitmId == receiptItem.itemEntity.toitmId));
              }
              final lowestPricePromo =
                  listTpsm1.reduce((current, next) => (current.price) < (next.price) ? current : next);
              final lowestPromo = availablePromos.where((element) =>
                  element?.promoId == lowestPricePromo.topsmId && element?.toitmId == lowestPricePromo.toitmId);
              availablePromos = availablePromos.where((element) => element?.promoType != 201).toList()
                ..add(lowestPromo.first);
            }
            for (final availablePromo in availablePromos) {
              if (skippedPromoIds.contains(availablePromo!.promoId)) continue;
              switch (availablePromo.promoType) {
                // Buy X Get Y
                case 103:
                  dev.log("103 checked");
                  // Check applicability
                  final CheckBuyXGetYApplicabilityResult checkBuyXGetYApplicability =
                      await _checkBuyXGetYApplicabilityUseCase.call(
                          params: CheckBuyXGetYApplicabilityParams(
                    receiptEntity: newReceipt,
                    receiptItemEntity: receiptItem,
                    promo: availablePromo,
                    returnItems: returnItems,
                  ));
                  dev.log("103 checked - ${checkBuyXGetYApplicability.isApplicable}");
                  if (!checkBuyXGetYApplicability.isApplicable) break;

                  // Show Pop Up
                  List<PromoBuyXGetYGetConditionAndItemEntity> selectedConditionAndItemYs = [];
                  dev.log("103 efevev");
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
                // Discount Item (Item)
                case 203:
                  dev.log("CASE 203");
                  newReceipt = await _handlePromoTopdiUseCase.call(
                      params: HandlePromosUseCaseParams(
                    receiptItemEntity: receiptItem,
                    receiptEntity: newReceipt,
                    promo: availablePromo,
                  ));
                // Discount Item (Group)
                case 204:
                  newReceipt = await _handlePromoTopdgUseCase.call(
                      params: HandlePromosUseCaseParams(
                    receiptItemEntity: receiptItem,
                    receiptEntity: newReceipt,
                    promo: availablePromo,
                  ));
                case 201:
                  // dev.log("CASE 201");
                  newReceipt = await _handlePromoSpesialMultiItemUseCase.call(
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
      }

      // Handle coupon
      if (newReceipt.coupons.isNotEmpty) {
        newReceipt = await _applyPromoToprnUseCase.call(
            params: ApplyPromoToprnUseCaseParams(receiptEntity: newReceipt, context: context));
      }

      // Reinsert return items
      if (returnItems.isNotEmpty) {
        final double subtotalAfterReturn = newReceipt.subtotal +
            returnItems.map((e) => e.totalGross).fold(0, (previousValue, element) => previousValue + element);
        final double taxAfterReturn = newReceipt.taxAmount +
            returnItems.map((e) => e.taxAmount).fold(0, (previousValue, element) => previousValue + element);
        final double grandTotalAfterReturn =
            subtotalAfterReturn - (newReceipt.discAmount ?? 0) - newReceipt.couponDiscount + taxAfterReturn;

        newReceipt = newReceipt.copyWith(
          subtotal: subtotalAfterReturn,
          discPrctg: (newReceipt.discAmount ?? 0) / subtotalAfterReturn,
          taxAmount: taxAfterReturn,
          receiptItems: newReceipt.receiptItems + returnItems,
          grandTotal: grandTotalAfterReturn,
        );
      }

      // Reinsert down payment
      if (newReceipt.downPayments != null &&
          (newReceipt.downPayments ?? []).isNotEmpty &&
          newReceipt.downPayments!.any((dp) => dp.isReceive == false) &&
          newReceipt.downPayments!.any((dp) => dp.isSelected == true)) {
        if (totalDPAmount > newReceipt.grandTotal) {
          throw "Down payment exceeds grand total (overpayment: ${Helpers.parseMoney(totalDPAmount - newReceipt.grandTotal)})";
        }
        double subTotal = newReceipt.subtotal;
        double dpSubTotal = subTotal - totalDPAmount;

        double dpGrandTotal =
            dpSubTotal - (newReceipt.discAmount ?? 0) + newReceipt.taxAmount - newReceipt.couponDiscount;

        newReceipt = newReceipt.copyWith(
          subtotal: dpSubTotal,
          discAmount: newReceipt.discAmount,
          discHeaderPromo: newReceipt.discHeaderPromo,
          discPrctg: dpSubTotal == 0 ? 0 : ((newReceipt.discAmount ?? 0) / dpSubTotal) * 100,
          taxAmount: newReceipt.taxAmount,
          grandTotal: dpGrandTotal,
        );
      } else if (dpItem != null && dpItem.quantity > 0) {
        newReceipt = await _recalculateReceiptUseCase.call(
            params: newReceipt.copyWith(
          receiptItems: [dpItem.copyWith()],
        ));
      }

      // Reapply manual header discount
      if (discHeaderManual > 0 && newReceipt.grandTotal + (dpItem?.totalAmount ?? 0) >= discHeaderManual) {
        newReceipt = await _recalculateTaxUseCase.call(
            params: newReceipt.copyWith(
          discHeaderManual: discHeaderManual,
          // subtotal: (newReceipt.subtotal + totalDPAmount),
          // grandTotal: (newReceipt.grandTotal + totalDPAmount),
          // discAmount: discHeaderManual + (newReceipt.discHeaderPromo ?? 0),
          // discPrctg: (100 * (discHeaderManual + (newReceipt.discHeaderPromo ?? 0))) / newReceipt.subtotal,
        ));
      }

      // Apply rounding
      newReceipt = await _applyRoundingUseCase.call(params: newReceipt);

      // dev.log("check last - ${newReceipt.grandTotal} - ${newReceipt.receiptItems}");
      emit(newReceipt.copyWith(
        previousReceiptEntity: initialState.previousReceiptEntity ??
            initialState.copyWith(
                receiptItems: initialState.receiptItems.map((e) => e.copyWith()).toList(), previousReceiptEntity: null),
      ));

      // dev.log("after emit ${state.receiptItems}");
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

  Future<void> applyManualRounding(RoundingMode mode, double? input) async {
    try {
      ReceiptEntity receiptRounded;
      if (mode == RoundingMode.down) {
        receiptRounded = await _applyManualRoundingDownUseCase.call(params: state);
      } else {
        receiptRounded = await _applyManualRoundingUpUseCase.call(params: state, amount: input);
      }
      emit(receiptRounded.copyWith(
          grandTotal: receiptRounded.grandTotal,
          rounding: receiptRounded.rounding,
          previousReceiptEntity: state.previousReceiptEntity));
    } catch (e) {
      dev.log('Error during rounding: $e');
      rethrow;
    }
  }

  void resetRounding(double originalValue) {
    emit(state.copyWith(
        grandTotal: originalValue,
        rounding: state.previousReceiptEntity?.rounding ?? 0,
        previousReceiptEntity: state.previousReceiptEntity));
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
  // final bool? isReinput;
  final double? setOpenPrice;
  final String? refpos2;
  final String? refpos3;
  final double? overridingPrice;
  final String? salesTohemId;

  AddUpdateReceiptItemsParams({
    required this.barcode,
    required this.itemEntity,
    required this.quantity,
    required this.context,
    required this.onOpenPriceInputted,
    this.remarks,
    this.tohemId,
    this.setOpenPrice,
    this.refpos2,
    this.refpos3,
    this.overridingPrice,
    this.salesTohemId,
  });
}
