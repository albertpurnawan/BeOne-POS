import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/edc.dart';
import 'package:sqflite/sqflite.dart';

class EDCDao extends BaseDao<EDCModel> {
  EDCDao(Database db)
      : super(db: db, tableName: tableEDC, modelFields: EDCFields.values);

  @override
  Future<EDCModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? EDCModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<EDCModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => EDCModel.fromMap(itemData)).toList();
  }
}
