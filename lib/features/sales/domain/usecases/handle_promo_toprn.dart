// import 'package:pos_fe/core/usecases/usecase.dart';
// import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
// import 'package:pos_fe/features/sales/domain/usecases/apply_promo_toprn.dart';
// import 'package:pos_fe/features/sales/domain/usecases/get_promo_toprn_header.dart';
// import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';
// import 'package:pos_fe/features/sales/domain/usecases/recalculate_receipt_by_toprn.dart';

// class HandlePromoToprnUseCase implements UseCase<ReceiptEntity, HandlePromosUseCaseParams> {
//   HandlePromoToprnUseCase(this._getPromoToprnHeaderAndDetailUseCaseResult, this._applyPromoToprnUseCase,
//       this._recalculateReceiptByToprnUseCase);

//   final GetPromoToprnHeaderAndDetailUseCaseResult _getPromoToprnHeaderAndDetailUseCaseResult;
//   final ApplyPromoToprnUseCase _applyPromoToprnUseCase;
//   final RecalculateReceiptByToprnUseCase _recalculateReceiptByToprnUseCase;

//   @override
//   Future<ReceiptEntity> call({HandlePromosUseCaseParams? params}) async {
//     try {
//       if (params == null) {
//         throw "HandlePromoToprnUseCase requires params";
//       }
//       final GetPromoToprnHeaderAndDetailUseCaseResult toprnHeader =
//           await _getPromoToprnHeaderAndDetailUseCaseResult.call(params: params.promo);

//       ReceiptEntity newReceipt = await _applyPromoToprnUseCase.call(
//           params: ApplyPromoToprnUseCaseParams(toprnHeader: toprnHeader, handlePromosUseCaseParams: params));

//       newReceipt = await _recalculateReceiptByToprnUseCase.call(params: newReceipt);
//       return newReceipt;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
