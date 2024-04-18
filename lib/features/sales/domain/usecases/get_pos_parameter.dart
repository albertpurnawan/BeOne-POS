import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/repository/pos_paramater_repository.dart';

class GetPosParameterUseCase implements UseCase<POSParameterEntity, void> {
  final POSParameterRepository _posParameterRepository;

  GetPosParameterUseCase(this._posParameterRepository);

  @override
  Future<POSParameterEntity> call({void params}) {
    // TODO: implement call
    return _posParameterRepository.getPosParameter();
  }
}
