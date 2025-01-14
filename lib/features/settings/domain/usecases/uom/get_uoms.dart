import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/uom.dart';
import 'package:pos_fe/features/settings/domain/repository/uom_repository.dart';

class GetUoMsUseCase implements UseCase<List<UomEntity>, void> {
  final UoMRepository _uoMRepository;

  GetUoMsUseCase(this._uoMRepository);

  @override
  Future<List<UomEntity>> call({void params}) {
    return _uoMRepository.getUoMs();
  }
}
