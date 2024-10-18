// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:developer';

// import 'package:pos_fe/core/usecases/usecase.dart';
// import 'package:pos_fe/features/sales/domain/entities/promo_coupon_header.dart';
// import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
// import 'package:pos_fe/features/sales/domain/usecases/get_promo_toprn_header.dart';
// import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

// class ApplyPromoToprnUseCase implements UseCase<ReceiptEntity, ApplyPromoToprnUseCaseParams> {
//   ApplyPromoToprnUseCase();

//   @override
//   Future<ReceiptEntity> call({ApplyPromoToprnUseCaseParams? params}) async {
//     try {
//       if (params == null) throw "ApplyPromoToprnUseCase requires params";

//       final List<PromoCouponHeaderEntity> toprn = params.toprnHeader.toprn;
//       final ReceiptEntity receiptEntity = params.handlePromosUseCaseParams.receiptEntity;

//       log("toprn - $toprn");
//       log("receiptEntity - $receiptEntity");

//       return receiptEntity;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }

// class ApplyPromoToprnUseCaseParams {
//   final GetPromoToprnHeaderAndDetailUseCaseResult toprnHeader;
//   final HandlePromosUseCaseParams handlePromosUseCaseParams;

//   ApplyPromoToprnUseCaseParams({required this.toprnHeader, required this.handlePromosUseCaseParams});
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_header.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promo_toprn_applicability.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_promo_toprn_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';
import 'package:pos_fe/features/sales/presentation/widgets/confirmation_dialog.dart';

class ApplyPromoToprnUseCase implements UseCase<ReceiptEntity, ApplyPromoToprnUseCaseParams> {
  ApplyPromoToprnUseCase();

  @override
  Future<ReceiptEntity> call({ApplyPromoToprnUseCaseParams? params}) async {
    try {
      if (params == null) throw "ApplyPromoToprnUseCase requires params";

      final ReceiptEntity receiptEntity = params.receiptEntity;
      final List<PromoCouponHeaderEntity> coupons = receiptEntity.coupons;
      final nonMember = await GetIt.instance<AppDatabase>().customerDao.readByCustCode("99", null);
      final customer = receiptEntity.customerEntity;

      final double subtotal = receiptEntity.subtotal;
      double taxAmount = 0;
      double discAmount = receiptEntity.discAmount ?? 0;
      List<PromotionsEntity> promos =
          receiptEntity.promos.where((element) => element.promoType != 107).map((e) => e.copyWith()).toList();

      double totalCouponDiscount = 0;
      double totalCouponDiscountPctg = 0;
      List<PromoCouponHeaderEntity> appliedCoupons = [];
      List<UnappliedCoupon> unappliedCoupons = [];
      List<PromotionsEntity> appliedCouponPromos = [];

      for (final coupon in coupons) {
        try {
          final GetPromoToprnHeaderAndDetailUseCaseResult couponHeaderAndDetail =
              await GetIt.instance<GetPromoToprnHeaderAndDetailUseCase>().call(params: coupon.couponCode);

          final CheckPromoToprnApplicabilityUseCaseResult checkCouponResult =
              await GetIt.instance<CheckPromoToprnApplicabilityUseCase>().call(
                  params: CheckPromoToprnApplicabilityUseCaseParams(
                      checkDuplicate: false,
                      toprnHeaderAndDetail: couponHeaderAndDetail,
                      handlePromosUseCaseParams: HandlePromosUseCaseParams(receiptEntity: receiptEntity)));

          if (checkCouponResult.isApplicable == false) throw checkCouponResult.failMsg;

          double couponDiscount = 0;
          double couponMaxDiscount = 0;
          double couponDiscPrctg = 0;
          double couponDiscAmt = 0;

          PromotionsEntity? promotionsEntity =
              await GetIt.instance<AppDatabase>().promosDao.readByPromoIdAndPromoType(coupon.docId, 107, null);
          if (promotionsEntity == null) {
            throw "Coupon '${coupon.couponCode}' not found, please remove coupon from transaction";
          }

          if (nonMember!.docId == customer!.docId) {
            couponDiscount = (coupon.generalDisc / 100) * (subtotal - discAmount - totalCouponDiscount);
            couponMaxDiscount = coupon.maxGeneralDisc;
          } else {
            couponDiscount = (coupon.memberDisc / 100) * (subtotal - discAmount - totalCouponDiscount);
            couponMaxDiscount = coupon.maxMemberDisc;
          }

          if (couponDiscount > couponMaxDiscount) {
            couponDiscPrctg = couponMaxDiscount / (subtotal - discAmount - totalCouponDiscount);
          } else {
            couponDiscPrctg = couponDiscount / (subtotal - discAmount - totalCouponDiscount);
          }

          couponDiscAmt = couponDiscPrctg * (subtotal - discAmount - totalCouponDiscount);
          log("couponDiscAmt - $couponDiscAmt");
          totalCouponDiscount += couponDiscAmt;

          appliedCoupons.add(coupon.copyWith());
          appliedCouponPromos.add(promotionsEntity
            ..discAmount = couponDiscAmt
            ..discPrctg = couponDiscPrctg);
        } catch (e) {
          unappliedCoupons.add(UnappliedCoupon(unappliedCoupon: coupon, failMsg: e.toString()));
          continue;
        }
      }

      totalCouponDiscountPctg = totalCouponDiscount / (subtotal - discAmount);
      for (final item in receiptEntity.receiptItems.map((e) => e.copyWith())) {
        final double afterDiscount =
            (1 - totalCouponDiscountPctg) * (item.totalGross - (item.discAmount ?? 0) - (item.discHeaderAmount ?? 0));
        taxAmount += afterDiscount * (item.itemEntity.taxRate / 100);
      }

      receiptEntity.taxAmount = taxAmount;
      receiptEntity.couponDiscount = totalCouponDiscount;
      receiptEntity.grandTotal = subtotal - discAmount - totalCouponDiscount + taxAmount;
      receiptEntity.promos = promos + appliedCouponPromos;
      receiptEntity.coupons = appliedCoupons;

      if (unappliedCoupons.isNotEmpty) {
        final String secondaryMsg =
            unappliedCoupons.map((e) => "${e.unappliedCoupon.couponCode} (${e.failMsg})").join("\n");
        await showDialog<bool>(
          context: params.context,
          barrierDismissible: false,
          builder: (context) => ConfirmationDialog(
            primaryMsg: "Some coupons are omitted from transaction",
            secondaryMsg: secondaryMsg,
            isProceedOnly: true,
          ),
        );
      }

      return receiptEntity;
    } catch (e) {
      throw "Failed to apply coupon, please remove coupon from transaction";
    }
  }
}

class ApplyPromoToprnUseCaseParams {
  final ReceiptEntity receiptEntity;
  final BuildContext context;

  ApplyPromoToprnUseCaseParams({
    required this.receiptEntity,
    required this.context,
  });
}

class UnappliedCoupon {
  PromoCouponHeaderEntity unappliedCoupon;
  String failMsg;

  UnappliedCoupon({
    required this.unappliedCoupon,
    required this.failMsg,
  });
}
