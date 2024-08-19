// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_customer_group.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_header.dart';

class GetPromoToprnHeaderAndDetailUseCase implements UseCase<GetPromoToprnHeaderAndDetailUseCaseResult, String> {
  GetPromoToprnHeaderAndDetailUseCase();

  @override
  Future<GetPromoToprnHeaderAndDetailUseCaseResult> call({String? params}) async {
    try {
      if (params == null) {
        throw "Coupon code required";
      }

      const String incompleDataErrMsg = "Coupon not found";

      log(params);
      final toprn = await GetIt.instance<AppDatabase>().promoCouponHeaderDao.readByCouponCode(params, null);
      log(toprn.toString());
      if (toprn == null) throw incompleDataErrMsg;

      final tprn4 = await GetIt.instance<AppDatabase>().promoCouponCustomerGroupDao.readByToprnId(toprn.docId, null);
      log(tprn4.toString());
      if (tprn4.isEmpty) throw incompleDataErrMsg;

      return GetPromoToprnHeaderAndDetailUseCaseResult(
        toprn: toprn,
        tprn4: tprn4,
      );
    } catch (e) {
      rethrow;
    }
  }
}

class GetPromoToprnHeaderAndDetailUseCaseResult {
  final PromoCouponHeaderEntity toprn;
  final List<PromoCouponCustomerGroupEntity> tprn4;

  GetPromoToprnHeaderAndDetailUseCaseResult({
    required this.toprn,
    required this.tprn4,
  });
}
