import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/repository/store_master_repository.dart';

class GetTaxSettingsUseCase implements UseCase<bool?, StoreMasterEntity> {
  final StoreMasterRepository _storeMasterRepository;

  GetTaxSettingsUseCase(this._storeMasterRepository);

  @override
  Future<bool?> call({StoreMasterEntity? params}) {
    return _storeMasterRepository.getTaxSettings(params!);
  }
}
