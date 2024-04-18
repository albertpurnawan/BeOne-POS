import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/item_by_store.dart';
import 'package:sqflite/sqflite.dart';

class ItemByStoreDao extends BaseDao<ItemByStoreModel> {
  ItemByStoreDao(Database db)
      : super(
            db: db,
            tableName: tableItemsByStore,
            modelFields: ItemsByStoreFields.values);

  @override
  Future<ItemByStoreModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ItemByStoreModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<ItemByStoreModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => ItemByStoreModel.fromMap(itemData))
        .toList();
  }
}
