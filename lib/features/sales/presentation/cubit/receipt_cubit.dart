// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/resources/error_handler.dart';
import 'package:pos_fe/core/resources/loop_tracker.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/invoice_service.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/invoice_header.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_rounding.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_buy_x_get_y_applicability.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/delete_queued_receipt_by_docId.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_cash_register.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_employee.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_by_barcode.dart';
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
  final GetPosParameterUseCase _getPosParameterUseCase;
  final GetStoreMasterUseCase _getStoreMasterUseCase;
  final GetCashRegisterUseCase _getCashRegisterUseCase;
  final ApplyRoundingUseCase _applyRoundingUseCase;

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
      if (params.quantity <= 0) {
        throw "Quantity must be greater than 0";
      }

      // Initialize some values
      if (state.receiptItems.isEmpty &&
          state.customerEntity?.custCode != "99") {
        await resetReceipt();
      }

      // Declare variables
      final ItemEntity? itemEntity;
      ReceiptItemEntity receiptItemEntity;
      final List<PromotionsEntity?> availablePromos;

      dev.log("addUpdateItems");
      dev.log(state.previousReceiptEntity.toString());

      if (state.previousReceiptEntity != null) {
        final bool? isProceed = await showDialog<bool>(
          context: params.context!,
          barrierDismissible: false,
          builder: (context) => ConfirmResetPromoDialog(),
        );
        if (isProceed == null) return;
        if (!isProceed) return;
      }
      ReceiptEntity newReceipt = state.previousReceiptEntity ?? state;

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
            context: params.context!,
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
      dev.log("item entity toitmid ${receiptItemEntity.itemEntity}");
      availablePromos = await _checkPromoUseCase(
          params: receiptItemEntity.itemEntity.toitmId);
      bool anyPromoApplied = false;
      if (availablePromos.isNotEmpty) {
        for (final availablePromo in availablePromos) {
          switch (availablePromo!.promoType) {
            case 202:
              dev.log("CASE 202");
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
            params: HandlePromosUseCaseParams(
                receiptItemEntity: receiptItemEntity,
                receiptEntity: newReceipt));
      }

      // Recalculate receipt
      newReceipt = await _recalculateReceiptUseCase.call(params: newReceipt);

      dev.log(
          "Result addUpdate ${newReceipt.copyWith(previousReceiptEntity: null)}");
      emit(newReceipt.copyWith(previousReceiptEntity: null));
    } catch (e, s) {
      dev.log(s.toString());
      if (params.context != null) {
        ErrorHandler.presentErrorSnackBar(params.context!, e.toString());
      }
    }
  }

  void updateMopSelection(
      {required MopSelectionEntity mopSelectionEntity,
      required double amountReceived}) {
    final newState = state.copyWith(
        mopSelection: mopSelectionEntity,
        totalPayment: amountReceived,
        totalNonVoucher: mopSelectionEntity.amount,
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
      totalPayment: (state.mopSelection?.amount ?? 0) + vouchersAmount,
      previousReceiptEntity: state.previousReceiptEntity,
    );

    emit(newState);
  }

  Future<void> updateCustomer(
      CustomerEntity customerEntity, BuildContext context) async {
    if (state.previousReceiptEntity != null &&
        state.customerEntity?.docId != customerEntity.docId) {
      final bool? isProceed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => ConfirmResetPromoDialog(),
      );
      if (isProceed == null) return;
      if (!isProceed) return;

      return emit(state.previousReceiptEntity!
          .copyWith(customerEntity: customerEntity));
    }
    emit(state.copyWith(
        customerEntity: customerEntity,
        previousReceiptEntity: state.previousReceiptEntity));
  }

  void removeReceiptItem(
      ReceiptItemEntity receiptItemEntity, BuildContext context) async {
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

    for (final currentReceiptItem
        in receiptEntity.receiptItems.map((e) => e.copyWith())) {
      if (receiptItemEntity.itemEntity.barcode !=
          currentReceiptItem.itemEntity.barcode) {
        newReceiptItems.add(currentReceiptItem);
      }
    }

    final ReceiptEntity newState = await _recalculateReceiptUseCase.call(
        params: receiptEntity.copyWith(
      receiptItems: newReceiptItems,
    ));

    dev.log("Remove Item $newState");

    emit(newState);
  }

  Future<void> charge() async {
    final newState =
        state.copyWith(changed: state.totalPayment! - state.grandTotal);

    dev.log("ON CHARGE - $newState");
    final ReceiptEntity? createdReceipt =
        await _saveReceiptUseCase.call(params: newState);

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
      dev.log("createdReceipt $createdReceipt");
      try {
        await _printReceiptUsecase.call(params: createdReceipt);
        await _openCashDrawerUseCase.call();
      } catch (e) {
        print(e);
      }
      final invHead =
          await GetIt.instance<AppDatabase>().invoiceHeaderDao.readByLastDate();
      final invHeadSuccess = InvoiceHeaderModel(
        docId: invHead[0].docId,
        createDate: invHead[0].createDate,
        updateDate: invHead[0].updateDate,
        tostrId: invHead[0].tostrId,
        docnum: invHead[0].docnum,
        orderNo: invHead[0].orderNo,
        tocusId: invHead[0].tocusId,
        tohemId: invHead[0].tohemId,
        transDateTime: invHead[0].transDateTime,
        timezone: invHead[0].timezone,
        remarks: invHead[0].remarks,
        subTotal: invHead[0].subTotal,
        discPrctg: invHead[0].discPrctg,
        discAmount: invHead[0].discAmount,
        discountCard: invHead[0].discountCard,
        coupon: invHead[0].coupon,
        discountCoupun: invHead[0].discountCoupun,
        taxPrctg: invHead[0].taxPrctg,
        taxAmount: invHead[0].taxAmount,
        addCost: invHead[0].addCost,
        rounding: invHead[0].rounding,
        grandTotal: invHead[0].grandTotal,
        changed: invHead[0].changed,
        totalPayment: invHead[0].totalPayment,
        tocsrId: invHead[0].tocsrId,
        docStatus: invHead[0].docStatus,
        sync: invHead[0].sync,
        syncCRM: invHead[0].syncCRM,
        tcsr1Id: invHead[0].tcsr1Id,
        toinvTohemId: invHead[0].toinvTohemId,
        refpos1: invHead[0].refpos1,
        refpos2: invHead[0].refpos2,
        discHeaderManual: invHead[0].discHeaderManual,
        discHeaderPromo: invHead[0].discHeaderPromo,
        syncToBos: invHead[0].syncToBos,
        paymentSuccess: '1',
      );
      await GetIt.instance<AppDatabase>()
          .invoiceHeaderDao
          .update(docId: invHead[0].docId!, data: invHeadSuccess);
      await GetIt.instance<InvoiceApi>().sendInvoice();
    }
  }

  Future<void> resetReceipt() async {
    try {
      final DateTime now = DateTime.now();
      final EmployeeEntity? employeeEntity = await _getEmployeeUseCase.call();
      final CustomerEntity? customerEntity = await GetIt.instance<AppDatabase>()
          .customerDao
          .readByCustCode("99", null);
      final List<InvoiceHeaderEntity> invoiceHeaderEntities =
          await GetIt.instance<AppDatabase>()
              .invoiceHeaderDao
              .readByShiftAndDatetime(now);
      final POSParameterEntity? posParameterEntity =
          await _getPosParameterUseCase.call();
      if (posParameterEntity == null) throw "POS Parameter not found";
      final StoreMasterEntity? storeMasterEntity = await _getStoreMasterUseCase
          .call(params: posParameterEntity!.tostrId);
      if (storeMasterEntity == null) throw "Store master not found";
      final CashRegisterEntity? cashRegisterEntity =
          await _getCashRegisterUseCase.call(
              params: posParameterEntity.tocsrId!);
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
      await GetIt.instance<AppDatabase>()
          .queuedInvoiceHeaderDao
          .deleteByDocId(state.queuedInvoiceHeaderDocId!, null);
    }
    await _queueReceiptUseCase.call(
        params: state.previousReceiptEntity ?? state);
    resetReceipt();
  }

  void retrieveFromQueue(
      ReceiptEntity receiptEntity, BuildContext context) async {
    await resetReceipt();

    for (final receiptItem in receiptEntity.receiptItems) {
      await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
          barcode: receiptItem.itemEntity.barcode,
          itemEntity: null,
          quantity: receiptItem.quantity,
          context: context,
          onOpenPriceInputted: () => receiptItem.itemEntity.price));
    }
    emit(state
      ..queuedInvoiceHeaderDocId = receiptEntity.queuedInvoiceHeaderDocId);
  }

  Future<void> updateTotalAmountFromDiscount(double discValue) async {
    try {
      if (discValue > state.subtotal + (state.discAmount ?? 0)) {
        throw "Discount amount invalid";
      }

      final ReceiptEntity newState = state.copyWith(
        discHeaderManual: discValue,
        discAmount: discValue + (state.discHeaderPromo ?? 0),
      );

      ReceiptEntity updatedReceipt =
          await _recalculateTaxUseCase.call(params: newState);

      dev.log("Result updateTotalAmountFromDiscount - $updatedReceipt");

      emit(updatedReceipt.copyWith(
          previousReceiptEntity: state.previousReceiptEntity ??
              state.copyWith(previousReceiptEntity: null)));
    } catch (e) {
      dev.log("Error during tax recalculation: $e");
      rethrow;
    }
  }

  Future<void> processReceiptBeforeCheckout(BuildContext context) async {
    try {
      ReceiptEntity newReceipt = state.copyWith(
        receiptItems: state.receiptItems.map((e) => e.copyWith()).toList(),
        previousReceiptEntity: state.previousReceiptEntity,

        // Reset MOP related fields
        vouchers: [],
        totalPayment: 0,
        changed: 0,
        totalVoucher: 0,
        totalNonVoucher: 0,
      )..mopSelection = null;
      List<String> skippedPromoIds = [];

      dev.log("First entry $newReceipt");

      final double discHeaderManual = state.discHeaderManual ?? 0;
      if (discHeaderManual > 0) {
        newReceipt = await _recalculateReceiptUseCase.call(
            params: newReceipt.copyWith(
          discHeaderManual: 0,
          discAmount: (newReceipt.discHeaderPromo ?? 0),
        ));
      }

      dev.log("Process before checkout $newReceipt");

      // ini artinya barang dari buy x get ga discan ulang
      for (final receiptItem in state.copyWith().receiptItems) {
        List<PromotionsEntity?> availablePromos = [];
        availablePromos =
            await _checkPromoUseCase(params: receiptItem.itemEntity.toitmId);

        if (availablePromos.isNotEmpty) {
          for (final availablePromo in availablePromos) {
            if (skippedPromoIds.contains(availablePromo!.promoId)) continue;
            switch (availablePromo.promoType) {
              case 103:
                // Check applicability
                final CheckBuyXGetYApplicabilityResult
                    checkBuyXGetYApplicability =
                    await _checkBuyXGetYApplicabilityUseCase.call(
                        params: CheckBuyXGetYApplicabilityParams(
                  receiptEntity: newReceipt,
                  receiptItemEntity: receiptItem,
                  promo: availablePromo,
                ));

                if (!checkBuyXGetYApplicability.isApplicable) break;

                // Show Pop Up
                List<PromoBuyXGetYGetConditionAndItemEntity>
                    selectedConditionAndItemYs = [];
                for (int i = 0;
                    i < checkBuyXGetYApplicability.availableApplyCount;
                    i++) {
                  final List<PromoBuyXGetYGetConditionAndItemEntity>
                      selectedConditionAndItemYsPerDialog = (await showDialog<
                              List<PromoBuyXGetYGetConditionAndItemEntity>>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => PromoGetYDialog(
                              conditionAndItemYs:
                                  checkBuyXGetYApplicability.conditionAndItemYs,
                              toprb: checkBuyXGetYApplicability.toprb!,
                              loopTracker: LoopTracker(
                                  currentLoop: i + 1,
                                  totalLoop: checkBuyXGetYApplicability
                                      .availableApplyCount),
                            ),
                          )) ??
                          [];
                  if (selectedConditionAndItemYsPerDialog.isEmpty) break;

                  for (final selectedConditionAndItemYPerDialog
                      in selectedConditionAndItemYsPerDialog) {
                    final List<PromoBuyXGetYGetConditionAndItemEntity>
                        existElements = selectedConditionAndItemYs
                            .where((element) =>
                                element.itemEntity.barcode ==
                                selectedConditionAndItemYPerDialog
                                    .itemEntity.barcode)
                            .toList();
                    final PromoBuyXGetYGetConditionAndItemEntity? existElement =
                        existElements.isEmpty ? null : existElements.first;
                    if (existElement != null) {
                      existElement.multiply += 1;
                    } else {
                      selectedConditionAndItemYs.add(
                          selectedConditionAndItemYPerDialog..multiply = 1);
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
                        conditionAndItemXs:
                            checkBuyXGetYApplicability.conditionAndItemXs,
                        existingReceiptItemXs:
                            checkBuyXGetYApplicability.existingReceiptItemXs,
                        conditionAndItemYs: selectedConditionAndItemYs));
                newReceipt =
                    await _recalculateReceiptUseCase.call(params: newReceipt);
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

      dev.log("Process after checkout $newReceipt");

      if (discHeaderManual > 0 &&
          (newReceipt.subtotal - (newReceipt.discAmount ?? 0)) >
              discHeaderManual) {
        newReceipt = await _recalculateTaxUseCase.call(
            params: newReceipt.copyWith(
                discHeaderManual: discHeaderManual,
                discAmount:
                    discHeaderManual + (newReceipt.discHeaderPromo ?? 0),
                discPrctg: (100 *
                        (discHeaderManual +
                            (newReceipt.discHeaderPromo ?? 0))) /
                    newReceipt.subtotal));
      }

      dev.log("Process reapply discount header $newReceipt");

      newReceipt = await _applyRoundingUseCase.call(params: newReceipt);

      dev.log("To emit ${newReceipt.copyWith(
        previousReceiptEntity: state.copyWith(
            receiptItems: state.receiptItems.map((e) => e.copyWith()).toList(),
            previousReceiptEntity: null),
      )}");

      emit(newReceipt.copyWith(
        previousReceiptEntity: state.previousReceiptEntity ??
            state.copyWith(
                receiptItems:
                    state.receiptItems.map((e) => e.copyWith()).toList(),
                previousReceiptEntity: null),
      ));
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
      )..mopSelection = null,
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
      )..mopSelection = null,
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

  AddUpdateReceiptItemsParams({
    required this.barcode,
    required this.itemEntity,
    required this.quantity,
    required this.context,
    required this.onOpenPriceInputted,
  });
}
