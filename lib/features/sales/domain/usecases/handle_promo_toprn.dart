// import 'package:pos_fe/core/usecases/usecase.dart';
// import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
// import 'package:pos_fe/features/sales/domain/usecases/apply_promo_toprn.dart';
// import 'package:pos_fe/features/sales/domain/usecases/get_promo_toprn_header.dart';
// import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

// class HandlePromoToprnUseCase implements UseCase<ReceiptEntity, HandlePromosUseCaseParams> {
//   HandlePromoToprnUseCase(
//       this._getPromoToprnHeaderUseCaseResult, this._applyPromoToprnUseCase, this._recalculateReceiptByToprnUseCase);

//   final GetPromoToprnHeaderUseCaseResult _getPromoToprnHeaderUseCaseResult;
//   final ApplyPromoToprnUseCase _applyPromoToprnUseCase;
//   final RecalculateReceiptByToprnUseCase _recalculateReceiptByToprnUseCase;

//   @override
//   Future<ReceiptEntity> call({HandlePromosUseCaseParams? params}) async {
//     try {
//       if (params == null) {
//         throw "HandlePromoToprnUseCase requires params";
//       }
//       // Get conditions
//       final GetPromoToprnHeaderUseCaseResult toprnHeader =
//           await _getPromoToprnHeaderUseCaseResult.call(params: params.promo);

//       // Check applicability
//       final bool isApplicable = await _checkPromoTopdiApplicabilityUseCase.call(
//           params: CheckPromoTopdiApplicabilityUseCaseParams(
//               topdiHeaderAndDetail: topdiHeaderAndDetail, handlePromosUseCaseParams: params));
//       if (!isApplicable) return params.receiptEntity;

//       ReceiptEntity newReceipt = await _applyPromoToprnUseCase.call(
//           params: ApplyPromoToprnUseCaseParams(toprnHeader: toprnHeader, handlePromosUseCaseParams: params));

//       newReceipt = await _recalculateReceiptByToprnUseCase.call(params: newReceipt);
//       return newReceipt;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
