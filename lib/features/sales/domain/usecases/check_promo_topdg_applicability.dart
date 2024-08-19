// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/customer_group.dart';
import 'package:pos_fe/features/sales/domain/entities/item_master.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_group_item_buy_condition.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_group_item_customer_group.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_group_item_header.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_group_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_promo_topdg_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class CheckPromoTopdgApplicabilityUseCase implements UseCase<bool, CheckPromoTopdgApplicabilityUseCaseParams> {
  CheckPromoTopdgApplicabilityUseCase(this._customerGroupRepository);

  final CustomerGroupRepository _customerGroupRepository;

  @override
  Future<bool> call({CheckPromoTopdgApplicabilityUseCaseParams? params}) async {
    try {
      if (params == null) {
        throw "CheckPromoTopdgApplicabilityUseCase requires params";
      }

      if (params.handlePromosUseCaseParams.receiptItemEntity == null) throw "Receipt item entity required";

      // Check applicability (general validation and branching)
      final PromoDiskonGroupItemHeaderEntity topdg = params.topdgHeaderAndDetail.topdg;
      final List<PromoDiskonGroupItemBuyConditionEntity> tpdg1 = params.topdgHeaderAndDetail.tpdg1;
      final List<PromoDiskonGroupItemCustomerGroupEntity> tpdg5 = params.topdgHeaderAndDetail.tpdg5;

      final ReceiptEntity receiptEntity = params.handlePromosUseCaseParams.receiptEntity;
      final ReceiptItemEntity receiptItemEntity = params.handlePromosUseCaseParams.receiptItemEntity!;

      bool isApplicable = true;

      final List<Function> generalValidations = [
        () async {
          if (receiptEntity.promos
              .where((element) => element.promoId == params.handlePromosUseCaseParams.promo!.promoId)
              .isNotEmpty) {
            return isApplicable = false;
          }
        },
        () async {
          // Check header: waktu, amount vs %
          final DateTime now = DateTime.now();
          final DateTime startPromo = DateTime(
            now.year,
            now.month,
            now.day,
            topdg.startTime.hour,
            topdg.startTime.minute,
            topdg.startTime.second,
          );
          final DateTime endPromo = DateTime(
            now.year,
            now.month,
            now.day,
            topdg.endTime.hour,
            topdg.endTime.minute,
            topdg.endTime.second,
          );

          if (now.millisecondsSinceEpoch < startPromo.millisecondsSinceEpoch ||
              now.millisecondsSinceEpoch > endPromo.millisecondsSinceEpoch) {
            return isApplicable = false;
          }

          if (topdg.promoValue > 0 && (topdg.discount1 > 0 || topdg.discount2 > 0 || topdg.discount3 > 0)) {
            return isApplicable = false;
          }
        },
        () async {
          // Check customer group
          if (receiptEntity.customerEntity == null) return isApplicable = false;
          if (receiptEntity.customerEntity!.tocrgId == null) {
            return isApplicable = false;
          }
          if (!tpdg5.map((e) => e.tocrgId).contains(receiptEntity.customerEntity!.tocrgId!)) {
            return isApplicable = false;
          }

          final CustomerGroupEntity? customerGroup =
              await _customerGroupRepository.getCustomerGroup(receiptEntity.customerEntity!.tocrgId!);
          if (customerGroup == null) return isApplicable = false;
        },
        () async {
          // Check category
          final ItemMasterEntity? itemMasterEntity =
              await GetIt.instance<AppDatabase>().itemMasterDao.readByDocId(receiptItemEntity.itemEntity.toitmId, null);
          // log(itemMasterEntity.toString());
          // log(tpdg1.map((e) => e.tocatId).toString());
          if (itemMasterEntity == null) return isApplicable = false;
          if (!tpdg1.map((e) => e.tocatId).contains(itemMasterEntity.tocatId)) {
            return isApplicable = false;
          }
        },
      ];

      // Check applicability for gabungan harga jual (and or)
      final List<Function> gabunganHargaJualValidations = [
        () async {
          // Check totalPriceFrom, totalPriceTo, and AND/OR
          if (topdg.totalPriceFrom == null || topdg.totalPriceTo == null) {
            return isApplicable = false;
          }

          Set<String> uniqueTocatId = {};
          double totalPriceOfSelectedGroup = 0;
          for (final receiptItem in receiptEntity.receiptItems) {
            if (tpdg1.map((e) => e.tocatId).contains(receiptItem.itemEntity.tocatId)) {
              uniqueTocatId.add(receiptItem.itemEntity.tocatId!);
              totalPriceOfSelectedGroup += receiptItem.totalAmount;
            }
          }

          if (topdg.buyCondition == 1 && (uniqueTocatId.length < tpdg1.length)) {
            return isApplicable = false;
          }
          if (topdg.buyCondition == 0 && uniqueTocatId.isEmpty) {
            return isApplicable = false;
          }

          if (totalPriceOfSelectedGroup < topdg.totalPriceFrom! || totalPriceOfSelectedGroup > topdg.totalPriceTo!) {
            return isApplicable = false;
          }
        }
      ];

      // Check applicability for gabungan jumlah (and or)
      final List<Function> gabunganJumlahValidations = [
        () async {
          // Check totalQtyFrom, totalQtyTo, AND/OR
          if (topdg.totalQtyFrom == null || topdg.totalQtyTo == null) {
            return isApplicable = false;
          }

          Set<String> uniqueTocatId = {};
          double totalQtyOfSelectedGroup = 0;
          for (final receiptItem in receiptEntity.receiptItems) {
            if (tpdg1.map((e) => e.tocatId).contains(receiptItem.itemEntity.tocatId)) {
              totalQtyOfSelectedGroup += receiptItem.quantity;
              uniqueTocatId.add(receiptItem.itemEntity.tocatId!);
            }
          }

          if (topdg.buyCondition == 1 && (uniqueTocatId.length < tpdg1.length)) {
            return isApplicable = false;
          }
          if (topdg.buyCondition == 0 && uniqueTocatId.isEmpty) {
            return isApplicable = false;
          }

          if (totalQtyOfSelectedGroup < topdg.totalQtyFrom! || totalQtyOfSelectedGroup > topdg.totalQtyTo!) {
            return isApplicable = false;
          }
        },
      ];

      int counter = 0;
      for (final validation in topdg.promoType == 1
          ? generalValidations + gabunganHargaJualValidations
          : generalValidations + gabunganJumlahValidations) {
        log(counter.toString());
        // log("--- validation ---");
        counter += 1;
        if (!isApplicable) break;
        try {
          await validation();
        } catch (e) {
          isApplicable = false;
        }
      }

      return isApplicable;
    } catch (e) {
      rethrow;
    }
  }
}

class CheckPromoTopdgApplicabilityUseCaseParams {
  final GetPromoTopdgHeaderAndDetailUseCaseResult topdgHeaderAndDetail;
  final HandlePromosUseCaseParams handlePromosUseCaseParams;

  CheckPromoTopdgApplicabilityUseCaseParams(
      {required this.topdgHeaderAndDetail, required this.handlePromosUseCaseParams});
}
