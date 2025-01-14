import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/store_master.dart';
import 'package:sqflite/sqflite.dart';

class StoreMasterDao extends BaseDao<StoreMasterModel> {
  StoreMasterDao(Database db) : super(db: db, tableName: tableStoreMasters, modelFields: StoreMasterFields.values);

  @override
  Future<StoreMasterModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? StoreMasterModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<StoreMasterModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => StoreMasterModel.fromMap(itemData)).toList();
  }

  Future<StoreMasterModel?> readByStoreCode(String storeCode, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: '${StoreMasterFields.storeCode} = ?',
      whereArgs: [storeCode],
    );

    return res.isNotEmpty ? StoreMasterModel.fromMap(res[0]) : null;
  }
}
