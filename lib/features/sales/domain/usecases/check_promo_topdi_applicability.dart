// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/customer_group.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_item_buy_condition.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_item_customer_group.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_item_header.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_group_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_promo_topdi_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class CheckPromoTopdiApplicabilityUseCase
    implements UseCase<bool, CheckPromoTopdiApplicabilityUseCaseParams> {
  CheckPromoTopdiApplicabilityUseCase(this._customerGroupRepository);

  final CustomerGroupRepository _customerGroupRepository;

  @override
  Future<bool> call({CheckPromoTopdiApplicabilityUseCaseParams? params}) async {
    try {
      if (params == null) {
        throw "CheckPromoTopdiApplicabilityUseCase requires params";
      }
      // Declare and assign variables
      final PromoDiskonItemHeaderEntity topdi =
          params.topdiHeaderAndDetail.topdi;
      final List<PromoDiskonItemBuyConditionEntity> tpdi1 =
          params.topdiHeaderAndDetail.tpdi1;
      final List<PromoDiskonItemCustomerGroupEntity> tpdi5 =
          params.topdiHeaderAndDetail.tpdi5;

      final ReceiptEntity receiptEntity =
          params.handlePromosUseCaseParams.receiptEntity;

      bool isApplicable = true;

      // General validations
      final List<Function> generalValidations = [
        () async {
          // Check whether promo already applied
          if (receiptEntity.promos
              .where((element) =>
                  element.promoId ==
                  params.handlePromosUseCaseParams.promo!.promoId)
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
            topdi.startDate.hour,
            topdi.startDate.minute,
            topdi.startDate.second,
          );
          final DateTime endPromo = DateTime(
            now.year,
            now.month,
            now.day,
            topdi.startDate.hour,
            topdi.startDate.minute,
            topdi.startDate.second,
          );

          if (now.millisecondsSinceEpoch < startPromo.millisecondsSinceEpoch &&
              now.millisecondsSinceEpoch > endPromo.millisecondsSinceEpoch) {
            return isApplicable = false;
          }

          if (topdi.promoValue > 0 &&
              (topdi.discount1 > 0 ||
                  topdi.discount2 > 0 ||
                  topdi.discount3 > 0)) {
            return isApplicable = false;
          }
        },
        () async {
          // Check customer group
          if (receiptEntity.customerEntity == null) return isApplicable = false;
          if (receiptEntity.customerEntity!.tocrgId == null) {
            return isApplicable = false;
          }
          if (!tpdi5
              .map((e) => e.tocrgId)
              .contains(receiptEntity.customerEntity!.tocrgId!)) {
            return isApplicable = false;
          }

          final CustomerGroupEntity? customerGroup =
              await _customerGroupRepository
                  .getCustomerGroup(receiptEntity.customerEntity!.tocrgId!);
          if (customerGroup == null) return isApplicable = false;
        },
      ];

      // Validations for nilai harga jual
      final List<Function> nilaiHargaJualValidations = [
        () async {
          // Check totalPriceFrom, totalPriceTo, and AND/OR
          if (!tpdi1.every((element) =>
              element.priceFrom != null && element.priceTo != null)) {
            return isApplicable = false;
          }

          Set<String> uniqueToitmId = {};
          for (final receiptItem in receiptEntity.receiptItems) {
            if (tpdi1
                .where((element) =>
                    element.toitmId == receiptItem.itemEntity.toitmId &&
                    element.priceFrom! <= receiptItem.totalGross &&
                    element.priceTo! >= receiptItem.totalGross)
                .isNotEmpty) {
              uniqueToitmId.add(receiptItem.itemEntity.toitmId);
            }
          }

          if (topdi.buyCondition == 1 &&
              (uniqueToitmId.length < tpdi1.length)) {
            return isApplicable = false;
          }
          if (topdi.buyCondition == 0 && uniqueToitmId.isEmpty) {
            return isApplicable = false;
          }
        },
      ];

      // Validations for jumlah jual
      final List<Function> jumlahJualValidations = [
        () async {
          // Check totalPriceFrom, totalPriceTo, and AND/OR
          if (!tpdi1.every(
              (element) => element.qtyFrom != null && element.qtyTo != null)) {
            return isApplicable = false;
          }

          Set<String> uniqueToitmId = {};
          for (final receiptItem in receiptEntity.receiptItems) {
            if (tpdi1
                .where((element) =>
                    element.toitmId == receiptItem.itemEntity.toitmId &&
                    element.qtyFrom! <= receiptItem.quantity &&
                    element.qtyTo! >= receiptItem.quantity)
                .isNotEmpty) {
              uniqueToitmId.add(receiptItem.itemEntity.toitmId);
            }
          }

          if (topdi.buyCondition == 1 &&
              (uniqueToitmId.length < tpdi1.length)) {
            return isApplicable = false;
          }
          if (topdi.buyCondition == 0 && uniqueToitmId.isEmpty) {
            return isApplicable = false;
          }
        },
      ];

      // Validations for gabungan harga jual (and or)
      final List<Function> gabunganHargaJualValidations = [
        () async {
          // Check totalPriceFrom, totalPriceTo, and AND/OR
          if (topdi.totalPriceFrom == null || topdi.totalPriceTo == null) {
            return isApplicable = false;
          }

          Set<String> uniqueToitmId = {};
          double totalPriceOfSelectedItem = 0;
          for (final receiptItem in receiptEntity.receiptItems) {
            if (tpdi1
                .map((e) => e.toitmId)
                .contains(receiptItem.itemEntity.toitmId)) {
              uniqueToitmId.add(receiptItem.itemEntity.toitmId);
              totalPriceOfSelectedItem += receiptItem.totalAmount;
            }
          }

          if (topdi.buyCondition == 1 &&
              (uniqueToitmId.length < tpdi1.length)) {
            return isApplicable = false;
          }
          if (topdi.buyCondition == 0 && uniqueToitmId.isEmpty) {
            return isApplicable = false;
          }

          if (totalPriceOfSelectedItem < topdi.totalPriceFrom! ||
              totalPriceOfSelectedItem > topdi.totalPriceTo!) {
            return isApplicable = false;
          }
        }
      ];

      // Validations for gabungan jumlah (and or)
      final List<Function> gabunganJumlahValidations = [
        () async {
          // Check totalQtyFrom, totalQtyTo, AND/OR
          if (topdi.totalQtyFrom == null || topdi.totalQtyTo == null) {
            return isApplicable = false;
          }

          Set<String> uniqueToitmId = {};
          double totalQtyOfSelectedItem = 0;
          for (final receiptItem in receiptEntity.receiptItems) {
            if (tpdi1.contains(receiptItem.itemEntity.toitmId)) {
              totalQtyOfSelectedItem += receiptItem.quantity;
              uniqueToitmId.add(receiptItem.itemEntity.toitmId);
            }
          }

          if (topdi.buyCondition == 1 &&
              (uniqueToitmId.length < tpdi1.length)) {
            return isApplicable = false;
          }
          if (topdi.buyCondition == 0 && uniqueToitmId.isEmpty) {
            return isApplicable = false;
          }

          if (totalQtyOfSelectedItem < topdi.totalQtyFrom! ||
              totalQtyOfSelectedItem > topdi.totalQtyTo!) {
            return isApplicable = false;
          }
        },
      ];

      // Generate final validations
      final List<Function> finalValidations = switch (topdi.promoType) {
        1 => generalValidations + nilaiHargaJualValidations,
        2 => generalValidations + jumlahJualValidations,
        3 => generalValidations + gabunganHargaJualValidations,
        4 => generalValidations + gabunganJumlahValidations,
        _ => [],
      };

      if (finalValidations.isEmpty) {
        isApplicable = false;
        return isApplicable;
      }

      // Run validations
      int counter = 0;
      for (final validation in finalValidations) {
        log(counter.toString());
        log("--- validation ---");
        counter += 1;
        if (!isApplicable) break;
        await validation();
      }

      // Return validation result
      return isApplicable;
    } catch (e) {
      rethrow;
    }
  }
}

class CheckPromoTopdiApplicabilityUseCaseParams {
  final GetPromoTopdiHeaderAndDetailUseCaseResult topdiHeaderAndDetail;
  final HandlePromosUseCaseParams handlePromosUseCaseParams;

  CheckPromoTopdiApplicabilityUseCaseParams(
      {required this.topdiHeaderAndDetail,
      required this.handlePromosUseCaseParams});
}
