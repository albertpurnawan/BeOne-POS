import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_spesial_multi_item_detail.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_spesial_multi_item_header.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_promo_topsm_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class ApplyTopsmUseCase implements UseCase<ReceiptEntity, ApplyPromoTopsmUseCaseParams> {
  ApplyTopsmUseCase();

  @override
  Future<ReceiptEntity> call({ApplyPromoTopsmUseCaseParams? params}) async {
    try {
      if (params == null) throw "ApplyPromoTopsmUseCase requires params";

      final PromoSpesialMultiItemHeaderEntity topsm = params.topsmHeaderAndDetail.topsm;
      final List<PromoSpesialMultiItemDetailEntity> tpsis = params.topsmHeaderAndDetail.tpsm1;

      final ReceiptEntity receiptEntity = params.handlePromosUseCaseParams.receiptEntity;
      final itemEntity = params.handlePromosUseCaseParams.receiptItemEntity!.itemEntity;
      final quantity = params.handlePromosUseCaseParams.receiptItemEntity!.quantity;

      for (var currentReceiptItem in receiptEntity.receiptItems) {}
      return receiptEntity.copyWith();
    } catch (e) {
      rethrow;
    }
  }
}

class ApplyPromoTopsmUseCaseParams {
  final GetPromoTopSmHeaderAndDetailUseCaseResult topsmHeaderAndDetail;
  final HandlePromosUseCaseParams handlePromosUseCaseParams;

  ApplyPromoTopsmUseCaseParams({required this.topsmHeaderAndDetail, required this.handlePromosUseCaseParams});
}
