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

import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';

class ApplyPromoToprnUseCase implements UseCase<ReceiptEntity, ReceiptEntity> {
  @override
  Future<ReceiptEntity> call({ReceiptEntity? params}) async {
    try {
      if (params == null) throw "ApplyPromoToprnUseCase requires params";

      final coupons = params.coupons;
      final nonMember = await GetIt.instance<AppDatabase>().customerDao.readByCustCode("99", null);
      final customer = params.customerEntity;

      double subtotal = params.subtotal;
      double grandTotal = params.grandTotal;
      double taxAmount = params.taxAmount;
      double? discNonMember = 0;
      double maxDiscNonMember = 0;
      double? discMember = 0;
      double maxDiscMember = 0;

      if (coupons == null) throw "ApplyPromoToprnUseCase requires coupons";
      for (final coupon in coupons) {
        if (nonMember!.docId == customer!.docId) {
          discNonMember = coupon.generalDisc * grandTotal;
          maxDiscNonMember = coupon.maxGeneralDisc;
          final prctg = maxDiscNonMember / subtotal;
          if (discNonMember > maxDiscNonMember) {
            taxAmount = taxAmount - ((1 - prctg) * taxAmount);
            subtotal = subtotal - ((1 - prctg) * maxDiscNonMember);
          } else {
            subtotal = subtotal - discNonMember;
            taxAmount = taxAmount - (coupon.generalDisc * taxAmount);
          }
        } else {
          discMember = coupon.memberDisc * grandTotal;
          maxDiscMember = coupon.maxMemberDisc;
          if (discMember > maxDiscMember) {
            grandTotal = grandTotal - maxDiscMember;
            // taxAmount = taxAmount - maxDiscMember;
          } else {
            subtotal = subtotal - (discMember * subtotal);
            taxAmount = taxAmount - (discMember * taxAmount);
          }
        }
      }

      log("discNonMember - $discNonMember");
      log("discMember - $discMember");
      log("taxAmount - $taxAmount");
      log("subtotal - $subtotal");

      return params.copyWith(subtotal: subtotal, taxAmount: taxAmount);
    } catch (e) {
      rethrow;
    }
  }
}
