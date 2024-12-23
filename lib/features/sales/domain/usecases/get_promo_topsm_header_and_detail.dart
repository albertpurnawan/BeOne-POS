import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_spesial_multi_item_customer_group.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_spesial_multi_item_detail.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_spesial_multi_item_header.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';

class GetPromoTopSmHeaderAndDetailUseCase
    implements UseCase<GetPromoTopSmHeaderAndDetailUseCaseResult, PromotionsEntity> {
  GetPromoTopSmHeaderAndDetailUseCase();

  @override
  Future<GetPromoTopSmHeaderAndDetailUseCaseResult> call({PromotionsEntity? params}) async {
    try {
      if (params == null) {
        throw "HandlePromoDiscItemByItemUseCase requires params";
      }

      if (params.promoId == null) {
        throw "PromoId required";
      }

      const String incompleDataErrMsg = "Promotion details incomplete";

      final topsm =
          await GetIt.instance<AppDatabase>().promoSpesialMultiItemHeaderDao.readByDocId(params.promoId!, null);
      if (topsm == null) throw incompleDataErrMsg;

      final tpsm1 =
          await GetIt.instance<AppDatabase>().promoSpesialMultiItemDetailDao.readAllByTopsmId(topsm.docId, null);
      if (tpsm1.isEmpty) throw incompleDataErrMsg;

      final tpsm4 =
          await GetIt.instance<AppDatabase>().promoSpesialMultiItemCustomerGroupDao.readByTopsmId(topsm.docId, null);
      if (tpsm4.isEmpty) throw incompleDataErrMsg;

      return GetPromoTopSmHeaderAndDetailUseCaseResult(
        topsm: topsm,
        tpsm1: tpsm1,
        tpsm4: tpsm4,
      );
    } catch (e) {
      rethrow;
    }
  }
}

class GetPromoTopSmHeaderAndDetailUseCaseResult {
  final PromoSpesialMultiItemHeaderEntity topsm;
  final List<PromoSpesialMultiItemDetailEntity> tpsm1;
  final List<PromoSpesialMultiItemCustomerGroupEntity> tpsm4;

  GetPromoTopSmHeaderAndDetailUseCaseResult({
    required this.topsm,
    required this.tpsm1,
    required this.tpsm4,
  });
}
