import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/item_master.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_repository.dart';
import 'package:pos_fe/features/syncdata/domain/repository/item_master_repository.dart';

class ItemMasterRepositoryImpl implements ItemMasterRepository {
  final AppDatabase _appDatabase;
  ItemMasterRepositoryImpl(this._appDatabase);

  @override
  Future<List<ItemMasterEntity>> getItemMastersByCategory(
      String tocatId) async {
    // TODO: implement getCustomers
    return await _appDatabase.itemMasterDao.readAllByTocatId(tocatId: tocatId);
  }
}
