import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/batch_credit_memo.dart';
import 'package:sqflite/sqflite.dart';

class BatchCreditMemoDao extends BaseDao<BatchCreditMemoModel> {
  BatchCreditMemoDao(Database db)
      : super(
          db: db,
          tableName: tableBatchCreditMemo,
          modelFields: BatchCreditMemoFields.values,
        );

  @override
  Future<BatchCreditMemoModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? BatchCreditMemoModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<BatchCreditMemoModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => BatchCreditMemoModel.fromMap(itemData))
        .toList();
  }
}
