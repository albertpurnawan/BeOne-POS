// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/customer_group.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_customer_group.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_header.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_group_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_promo_toprn_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class CheckPromoToprnApplicabilityUseCase implements UseCase<bool, CheckPromoToprnApplicabilityUseCaseParams> {
  CheckPromoToprnApplicabilityUseCase(this._customerGroupRepository);

  final CustomerGroupRepository _customerGroupRepository;

  @override
  Future<bool> call({CheckPromoToprnApplicabilityUseCaseParams? params}) async {
    try {
      if (params == null) {
        throw "CheckPromoToprnApplicabilityUseCase requires params";
      }
      // Check applicability (general validation and branching)
      final PromoCouponHeaderEntity toprn = params.toprnHeaderAndDetail.toprn;
      final List<PromoCouponCustomerGroupEntity> tprn4 = params.toprnHeaderAndDetail.tprn4;

      final ReceiptEntity receiptEntity = params.handlePromosUseCaseParams.receiptEntity;

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
            toprn.startTime.hour,
            toprn.startTime.minute,
            toprn.startTime.second,
          );
          final DateTime endPromo = DateTime(
            now.year,
            now.month,
            now.day,
            toprn.endTime.hour,
            toprn.endTime.minute,
            toprn.endTime.second,
          );

          if (now.millisecondsSinceEpoch < startPromo.millisecondsSinceEpoch ||
              now.millisecondsSinceEpoch > endPromo.millisecondsSinceEpoch) {
            return isApplicable = false;
          }

          if (toprn.generalDisc <= 0 ||
              toprn.maxGeneralDisc <= 0 ||
              toprn.memberDisc <= 0 ||
              toprn.maxMemberDisc <= 0) {
            return isApplicable = false;
          }
        },
        () async {
          // Check customer group
          if (receiptEntity.customerEntity == null) return isApplicable = false;
          if (receiptEntity.customerEntity!.tocrgId == null) {
            return isApplicable = false;
          }
          if (!tprn4.map((e) => e.tocrgId).contains(receiptEntity.customerEntity!.tocrgId!)) {
            return isApplicable = false;
          }

          final CustomerGroupEntity? customerGroup =
              await _customerGroupRepository.getCustomerGroup(receiptEntity.customerEntity!.tocrgId!);
          if (customerGroup == null) return isApplicable = false;
        },
        () async {
          // Check min purchase
          if (receiptEntity.grandTotal > toprn.minPurchase) return isApplicable = false;
        }
      ];

      int counter = 0;
      for (final validation in generalValidations) {
        log(counter.toString());
        log("--- validation ---");
        counter += 1;
        if (!isApplicable) break;
        await validation();
      }

      return isApplicable;
    } catch (e) {
      rethrow;
    }
  }
}

class CheckPromoToprnApplicabilityUseCaseParams {
  final GetPromoToprnHeaderAndDetailUseCaseResult toprnHeaderAndDetail;
  final HandlePromosUseCaseParams handlePromosUseCaseParams;

  CheckPromoToprnApplicabilityUseCaseParams(
      {required this.toprnHeaderAndDetail, required this.handlePromosUseCaseParams});
}
