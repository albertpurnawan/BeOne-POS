// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_item_buy_condition.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_item_customer_group.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_item_header.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';

class GetPromoTopdiHeaderAndDetailUseCase
    implements
        UseCase<GetPromoTopdiHeaderAndDetailUseCaseResult, PromotionsEntity> {
  GetPromoTopdiHeaderAndDetailUseCase();

  @override
  Future<GetPromoTopdiHeaderAndDetailUseCaseResult> call(
      {PromotionsEntity? params}) async {
    try {
      if (params == null) {
        throw "HandlePromoDiscItemByItemUseCase requires params";
      }

      if (params.promoId == null) {
        throw "PromoId required";
      }

      const String incompleDataErrMsg = "Promotion details incomplete";

      final topdi = await GetIt.instance<AppDatabase>()
          .promoDiskonItemHeaderDao
          .readByDocId(params.promoId!, null);
      if (topdi == null) throw incompleDataErrMsg;

      final tpdi1 = await GetIt.instance<AppDatabase>()
          .promoDiskonItemBuyConditionDao
          .readByTopdiId(topdi.docId, null);
      if (tpdi1.isEmpty) throw incompleDataErrMsg;

      final tpdi5 = await GetIt.instance<AppDatabase>()
          .promoDiskonItemCustomerGroupDao
          .readByTopdiId(topdi.docId, null);
      if (tpdi5.isEmpty) throw incompleDataErrMsg;

      return GetPromoTopdiHeaderAndDetailUseCaseResult(
        topdi: topdi,
        tpdi1: tpdi1,
        tpdi5: tpdi5,
      );
    } catch (e) {
      rethrow;
    }
  }
}

class GetPromoTopdiHeaderAndDetailUseCaseResult {
  final PromoDiskonItemHeaderEntity topdi;
  final List<PromoDiskonItemBuyConditionEntity> tpdi1;
  final List<PromoDiskonItemCustomerGroupEntity> tpdi5;

  GetPromoTopdiHeaderAndDetailUseCaseResult({
    required this.topdi,
    required this.tpdi1,
    required this.tpdi5,
  });
}
