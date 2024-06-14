import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/item_master.dart';
import 'package:sqflite/sqflite.dart';

class ItemMasterDao extends BaseDao<ItemMasterModel> {
  ItemMasterDao(Database db)
      : super(
            db: db,
            tableName: tableItemMasters,
            modelFields: ItemMasterFields.values);

  @override
  Future<ItemMasterModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ItemMasterModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<ItemMasterModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => ItemMasterModel.fromMap(itemData)).toList();
  }

  Future<List<ItemMasterModel>> readAllByTocatId(
      {required String tocatId, Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor
        .query(tableName, where: "tocatId = ?", whereArgs: [tocatId]);

    return result.map((itemData) => ItemMasterModel.fromMap(itemData)).toList();
  }
}
