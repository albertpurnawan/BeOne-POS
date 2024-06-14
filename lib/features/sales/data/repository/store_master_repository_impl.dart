import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/repository/store_master_repository.dart';

class StoreMasterRepositoryImpl implements StoreMasterRepository {
  final AppDatabase appDatabase;

  StoreMasterRepositoryImpl(this.appDatabase);

  @override
  Future<StoreMasterEntity?> getStoreMaster(String docId) async {
    return await appDatabase.storeMasterDao.readByDocId(docId, null);
  }
}
