import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/repository/promos_repository.dart';

class CheckPromoUseCase implements UseCase<List<PromotionsEntity?>, String?> {
  final PromotionsRepository _promotionsRepository;

  CheckPromoUseCase(this._promotionsRepository);

  @override
  Future<List<PromotionsEntity?>> call({String? params}) async {
    // TODO: implement call
    return await _promotionsRepository.checkPromos();
  }
}
