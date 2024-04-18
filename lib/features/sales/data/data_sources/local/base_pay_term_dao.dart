import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/base_pay_term.dart';
import 'package:sqflite/sqflite.dart';

class BasePayTermDao extends BaseDao<BasePayTermModel> {
  BasePayTermDao(Database db)
      : super(
          db: db,
          tableName: tableBasePayTerm,
          modelFields: BasePayTermFields.values,
        );

  @override
  Future<BasePayTermModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? BasePayTermModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<BasePayTermModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => BasePayTermModel.fromMap(itemData))
        .toList();
  }
}
