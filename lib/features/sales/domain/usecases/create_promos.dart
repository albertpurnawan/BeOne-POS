import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/repository/promos_repository.dart';

class CreatePromotionsUseCase implements UseCase<void, PromotionsEntity> {
  final PromotionsRepository _promotionsRepository;

  CreatePromotionsUseCase(this._promotionsRepository);

  @override
  Future<PromotionsEntity?> call({PromotionsEntity? params}) async {
    return await _promotionsRepository.createPromotion(params!);
  }
}
