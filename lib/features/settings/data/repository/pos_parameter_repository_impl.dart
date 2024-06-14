import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/repository/pos_paramater_repository.dart';

class POSParameterRepositoryImpl implements POSParameterRepository {
  final AppDatabase appDatabase;

  POSParameterRepositoryImpl(this.appDatabase);

  @override
  Future<void> createPosParameter(POSParameterEntity posParameterEntity) async {
    await appDatabase.posParameterDao
        .create(data: POSParameterModel.fromEntity(posParameterEntity));
  }

  @override
  Future<POSParameterEntity> getPosParameter() async {
    return (await appDatabase.posParameterDao.readAll()).first;
  }

  @override
  Future<void> updatePosParemeter(POSParameterEntity posParameterEntity) async {
    await appDatabase.posParameterDao.update(
        docId: posParameterEntity.docId,
        data: POSParameterModel.fromEntity(posParameterEntity));
  }
}
