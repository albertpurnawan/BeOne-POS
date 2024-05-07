import 'package:pos_fe/features/sales/domain/entities/promotions.dart';

abstract class PromotionsRepository {
  Future<List<PromotionsEntity?>> checkPromos(String toitmId);

  Future<List<PromotionsEntity?>> createPromotions(
      PromotionsEntity promotionsEntity);
}
