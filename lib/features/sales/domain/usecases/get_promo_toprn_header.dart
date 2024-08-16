// import 'package:get_it/get_it.dart';
// import 'package:pos_fe/core/database/app_database.dart';
// import 'package:pos_fe/core/usecases/usecase.dart';
// import 'package:pos_fe/features/sales/domain/entities/promo_coupon_header.dart';
// import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
// import 'package:pos_fe/features/sales/domain/entities/receipt.dart';

// class GetPromoToprnHeaderAndDetailUseCase implements UseCase<GetPromoToprnHeaderAndDetailUseCaseResult, ReceiptEntity> {
//   GetPromoToprnHeaderAndDetailUseCase();

//   @override
//   Future<GetPromoToprnHeaderAndDetailUseCaseResult> call({ReceiptEntity? params}) async {
//     try {
//       if (params == null) {
//         throw "HandlePromoCouponUseCase requires params";
//       }
//       if (params.coupons == null) {
//         throw "PromoId required";
//       }
//       const String incompleDataErrMsg = "Promotion details incomplete";

//       final toprn = await GetIt.instance<AppDatabase>().promoCouponHeaderDao.readAll();
//       if (toprn.isEmpty) throw incompleDataErrMsg;

//       return GetPromoToprnHeaderAndDetailUseCaseResult(
//         toprn: toprn,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
// }

// class GetPromoToprnHeaderAndDetailUseCaseResult {
//   final List<PromoCouponHeaderEntity> toprn;

//   GetPromoToprnHeaderAndDetailUseCaseResult({
//     required this.toprn,
//   });

//   call({PromotionsEntity? params}) {}
// }
