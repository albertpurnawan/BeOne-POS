import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/log_error.dart';
import 'package:sqflite/sqflite.dart';

class LogErrorDao extends BaseDao<LogErrorModel> {
  LogErrorDao(Database db)
      : super(
          db: db,
          tableName: tableLogError,
          modelFields: LogErrorFields.values,
        );

  @override
  Future<LogErrorModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? LogErrorModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<LogErrorModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result.map((itemData) => LogErrorModel.fromMap(itemData)).toList();
  }

  Future<void> clearDb({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    await dbExecutor.delete(tableName);
  }
}
