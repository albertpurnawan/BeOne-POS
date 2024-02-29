import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/uom.dart';
import 'package:pos_fe/features/syncdata/domain/repository/uom_repository.dart';

class GetUoMUseCase implements UseCase<UomEntity?, String> {
  final UoMRepository _uoMRepository;

  GetUoMUseCase(this._uoMRepository);

  @override
  Future<UomEntity?> call({String? params}) {
    // TODO: implement call
    return _uoMRepository.getSingleUoM();
  }
}
