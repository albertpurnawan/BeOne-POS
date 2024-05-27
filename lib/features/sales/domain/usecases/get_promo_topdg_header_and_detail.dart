// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_group_item_buy_condition.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_group_item_customer_group.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_group_item_header.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';

class GetPromoTopdgHeaderAndDetailUseCase
    implements
        UseCase<GetPromoTopdgHeaderAndDetailUseCaseResult, PromotionsEntity> {
  GetPromoTopdgHeaderAndDetailUseCase();

  @override
  Future<GetPromoTopdgHeaderAndDetailUseCaseResult> call(
      {PromotionsEntity? params}) async {
    try {
      if (params == null) {
        throw "HandlePromoDiscItemByItemUseCase requires params";
      }

      if (params.promoId == null) {
        throw "PromoId required";
      }

      const String incompleDataErrMsg = "Promotion details incomplete";

      final topdg = await GetIt.instance<AppDatabase>()
          .promoDiskonGroupItemHeaderDao
          .readByDocId(params.promoId!, null);
      if (topdg == null) throw incompleDataErrMsg;

      final tpdg1 = await GetIt.instance<AppDatabase>()
          .promoDiskonGroupItemBuyConditionDao
          .readByTopdgId(topdg.docId, null);
      if (tpdg1.isEmpty) throw incompleDataErrMsg;

      final tpdg5 = await GetIt.instance<AppDatabase>()
          .promoDiskonGroupItemCustomerGroupDao
          .readByTopdgId(topdg.docId, null);
      if (tpdg5.isEmpty) throw incompleDataErrMsg;

      return GetPromoTopdgHeaderAndDetailUseCaseResult(
        topdg: topdg,
        tpdg1: tpdg1,
        tpdg5: tpdg5,
      );
    } catch (e) {
      rethrow;
    }
  }
}

class GetPromoTopdgHeaderAndDetailUseCaseResult {
  final PromoDiskonGroupItemHeaderEntity topdg;
  final List<PromoDiskonGroupItemBuyConditionEntity> tpdg1;
  final List<PromoDiskonGroupItemCustomerGroupEntity> tpdg5;

  GetPromoTopdgHeaderAndDetailUseCaseResult({
    required this.topdg,
    required this.tpdg1,
    required this.tpdg5,
  });
}
