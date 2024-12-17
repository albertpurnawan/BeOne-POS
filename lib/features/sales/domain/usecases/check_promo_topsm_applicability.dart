import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/customer_group.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_spesial_multi_item_customer_group.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_spesial_multi_item_detail.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_spesial_multi_item_header.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_group_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_promo_topsm_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class CheckPromoTopsmApplicabilityUseCase implements UseCase<bool, CheckPromoTopsmApplicabilityUseCaseParams> {
  final CustomerGroupRepository _customerGroupRepository;
  CheckPromoTopsmApplicabilityUseCase(this._customerGroupRepository);

  @override
  Future<bool> call({CheckPromoTopsmApplicabilityUseCaseParams? params}) async {
    try {
      if (params == null) {
        throw "CheckPromoTopsmApplicabilityUseCase requires params";
      }

      if (params.handlePromosUseCaseParams.receiptItemEntity == null) throw "Receipt item entity required";

      // Check applicability (general validation and branching)
      final PromoSpesialMultiItemHeaderEntity topsm = params.topsmHeaderAndDetail.topsm;
      final List<PromoSpesialMultiItemDetailEntity> tpsm1 = params.topsmHeaderAndDetail.tpsm1;
      final List<PromoSpesialMultiItemCustomerGroupEntity> tpsm4 = params.topsmHeaderAndDetail.tpsm4;

      final ReceiptEntity receiptEntity = params.handlePromosUseCaseParams.receiptEntity;
      final ReceiptItemEntity? receiptItemEntity = params.handlePromosUseCaseParams.receiptItemEntity;
      if (receiptItemEntity == null) throw "Internal error on discount item by group applicability check";

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
            topsm.startTime.hour,
            topsm.startTime.minute,
            topsm.startTime.second,
          );
          final DateTime endPromo = DateTime(
            now.year,
            now.month,
            now.day,
            topsm.endTime.hour,
            topsm.endTime.minute,
            topsm.endTime.second,
          );

          if (now.millisecondsSinceEpoch < startPromo.millisecondsSinceEpoch ||
              now.millisecondsSinceEpoch > endPromo.millisecondsSinceEpoch) {
            return isApplicable = false;
          }
        },
        () async {
          // Check customer group
          if (receiptEntity.customerEntity == null) return isApplicable = false;
          if (receiptEntity.customerEntity!.tocrgId == null) {
            return isApplicable = false;
          }
          if (!tpsm4.map((e) => e.tocrgId).contains(receiptEntity.customerEntity!.tocrgId!)) {
            return isApplicable = false;
          }

          final CustomerGroupEntity? customerGroup =
              await _customerGroupRepository.getCustomerGroup(receiptEntity.customerEntity!.tocrgId!);
          if (customerGroup == null) return isApplicable = false;
        },
      ];

      // Validations for jumlah jual
      final List<Function> quantityValidation = [
        () async {
          // Check if all tpsm1 items have a corresponding receiptItem that fulfills the quantity
          bool allItemsFulfilled = tpsm1.every((ruleItem) {
            return receiptEntity.receiptItems.any((receiptItem) =>
                ruleItem.toitmId == receiptItem.itemEntity.toitmId &&
                ruleItem.qtyFrom <= receiptItem.quantity &&
                ruleItem.qtyTo >= receiptItem.quantity);
          });

          // Validation for condition == 1
          if (topsm.condition == 1 && !allItemsFulfilled) {
            return isApplicable = false;
          }

          // Validation for condition == 0
          if (topsm.condition == 0) {
            Set<String> uniqueToitmId = {};
            for (final receiptItem in receiptEntity.receiptItems) {
              if (tpsm1.any((element) =>
                  element.toitmId == receiptItem.itemEntity.toitmId &&
                  element.qtyFrom <= receiptItem.quantity &&
                  element.qtyTo >= receiptItem.quantity)) {
                uniqueToitmId.add(receiptItem.itemEntity.toitmId);
              }
            }

            if (uniqueToitmId.isEmpty) {
              return isApplicable = false;
            }
          }
        },
      ];

      // Generate final validations
      final List<Function> finalValidations = switch (topsm.condition) {
        0 => generalValidations + quantityValidation,
        1 => generalValidations + quantityValidation,
        _ => [],
      };

      if (finalValidations.isEmpty) {
        isApplicable = false;
        return isApplicable;
      }

      // Run validations
      // int counter = 0;
      for (final validation in finalValidations) {
        // log(counter.toString());
        // log("--- validation ---");
        // counter += 1;
        if (!isApplicable) break;
        try {
          await validation();
        } catch (e) {
          isApplicable = false;
        }
      }

      // Return validation result
      return isApplicable;
    } catch (e) {
      rethrow;
    }
  }
}

class CheckPromoTopsmApplicabilityUseCaseParams {
  final GetPromoTopSmHeaderAndDetailUseCaseResult topsmHeaderAndDetail;
  final HandlePromosUseCaseParams handlePromosUseCaseParams;

  CheckPromoTopsmApplicabilityUseCaseParams(
      {required this.topsmHeaderAndDetail, required this.handlePromosUseCaseParams});
}
