import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/repository/store_master_repository.dart';

class GetStoreMasterUseCase implements UseCase<StoreMasterEntity, void> {
  final StoreMasterRepository _storeMasterRepository;

  GetStoreMasterUseCase(this._storeMasterRepository);

  @override
  Future<StoreMasterEntity> call({void params}) {
    return _storeMasterRepository.getStoreMaster();
  }
}
