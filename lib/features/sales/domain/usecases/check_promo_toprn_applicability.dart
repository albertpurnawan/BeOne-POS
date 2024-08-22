// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:get_it/get_it.dart';

import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/domain/entities/customer_group.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_customer_group.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_header.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_group_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_promo_toprn_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class CheckPromoToprnApplicabilityUseCase
    implements UseCase<CheckPromoToprnApplicabilityUseCaseResult, CheckPromoToprnApplicabilityUseCaseParams> {
  CheckPromoToprnApplicabilityUseCase(this._customerGroupRepository);

  final CustomerGroupRepository _customerGroupRepository;

  @override
  Future<CheckPromoToprnApplicabilityUseCaseResult> call({CheckPromoToprnApplicabilityUseCaseParams? params}) async {
    try {
      if (params == null) {
        throw "CheckPromoToprnApplicabilityUseCase requires params";
      }
      // Check applicability (general validation and branching)
      final PromoCouponHeaderEntity toprn = params.toprnHeaderAndDetail.toprn;
      final List<PromoCouponCustomerGroupEntity> tprn4 = params.toprnHeaderAndDetail.tprn4;

      final ReceiptEntity receiptEntity = params.handlePromosUseCaseParams.receiptEntity;

      bool isApplicable = true;
      String failMsg = "";

      final List<Function> generalValidations = [
        () async {
          final PromotionsEntity? promo =
              await GetIt.instance<AppDatabase>().promosDao.readByPromoIdAndPromoType(toprn.docId, 107, null);
          if (promo == null) {
            failMsg = "Coupon inactive or inapplicable today";
            return isApplicable = false;
          }
        },
        () async {
          if (params.checkDuplicate == false) return null;
          if (receiptEntity.coupons.where((element) => element.docId == toprn.docId).isNotEmpty) {
            failMsg = "Coupon already applied";
            return isApplicable = false;
          }
        },
        () async {
          if (receiptEntity.coupons.isNotEmpty && toprn.includePromo == 0) {
            failMsg = "This coupon cannot include another coupon promo";
            return isApplicable = false;
          }
        },
        () async {
          if (receiptEntity.coupons.where((element) => element.includePromo == 0).isNotEmpty) {
            failMsg = "An existing coupon cannot include another coupon promo";
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

          log("$startPromo $endPromo");

          if (now.millisecondsSinceEpoch < startPromo.millisecondsSinceEpoch ||
              now.millisecondsSinceEpoch > endPromo.millisecondsSinceEpoch) {
            failMsg = "Coupon is invalid on current time";
            return isApplicable = false;
          }

          if (toprn.generalDisc <= 0 ||
              toprn.maxGeneralDisc <= 0 ||
              toprn.memberDisc <= 0 ||
              toprn.maxMemberDisc <= 0) {
            failMsg = "Invalid discount data";
            return isApplicable = false;
          }
        },
        () async {
          // Check customer group
          if (receiptEntity.customerEntity == null) {
            failMsg = "Null customer";
            return isApplicable = false;
          }

          if (receiptEntity.customerEntity!.tocrgId == null) {
            failMsg = "Null customer group";
            return isApplicable = false;
          }

          if (!tprn4.map((e) => e.tocrgId).contains(receiptEntity.customerEntity!.tocrgId!)) {
            failMsg = "Invalid customer group";
            return isApplicable = false;
          }

          final CustomerGroupEntity? customerGroup =
              await _customerGroupRepository.getCustomerGroup(receiptEntity.customerEntity!.tocrgId!);
          if (customerGroup == null) {
            failMsg = "Customer group not found";
            return isApplicable = false;
          }
        },
        () async {
          // Check min purchase
          if (receiptEntity.grandTotal < toprn.minPurchase) {
            failMsg = "Minimum purchase not fulfilled (${Helpers.parseMoney(toprn.minPurchase)})";
            return isApplicable = false;
          }
        }
      ];

      int counter = 0;
      for (final validation in generalValidations) {
        log(counter.toString());
        log("--- validation ---");
        counter += 1;
        if (!isApplicable) break;
        try {
          await validation();
        } catch (e) {
          failMsg = e.toString();
          isApplicable = false;
        }
      }

      return CheckPromoToprnApplicabilityUseCaseResult(isApplicable: isApplicable, failMsg: failMsg);
    } catch (e) {
      rethrow;
    }
  }
}

class CheckPromoToprnApplicabilityUseCaseParams {
  final GetPromoToprnHeaderAndDetailUseCaseResult toprnHeaderAndDetail;
  final HandlePromosUseCaseParams handlePromosUseCaseParams;
  final bool checkDuplicate;

  CheckPromoToprnApplicabilityUseCaseParams({
    required this.toprnHeaderAndDetail,
    required this.handlePromosUseCaseParams,
    required this.checkDuplicate,
  });
}

class CheckPromoToprnApplicabilityUseCaseResult {
  final bool isApplicable;
  final String failMsg;

  CheckPromoToprnApplicabilityUseCaseResult({
    required this.isApplicable,
    required this.failMsg,
  });
}
