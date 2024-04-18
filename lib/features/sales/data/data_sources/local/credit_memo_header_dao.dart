import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/credit_memo_header.dart';
import 'package:sqflite/sqflite.dart';

class CreditMemoHeaderDao extends BaseDao<CreditMemoHeaderModel> {
  CreditMemoHeaderDao(Database db)
      : super(
          db: db,
          tableName: tableCreditMemoHeader,
          modelFields: CreditMemoHeaderFields.values,
        );

  @override
  Future<CreditMemoHeaderModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? CreditMemoHeaderModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<CreditMemoHeaderModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => CreditMemoHeaderModel.fromMap(itemData))
        .toList();
  }
}
