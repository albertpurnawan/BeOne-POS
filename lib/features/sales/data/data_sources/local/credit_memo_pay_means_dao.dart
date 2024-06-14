import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/credit_memo_pay_means.dart';
import 'package:sqflite/sqflite.dart';

class CreditMemoPayMeansDao extends BaseDao<CreditMemoPayMeansModel> {
  CreditMemoPayMeansDao(Database db)
      : super(
          db: db,
          tableName: tableCreditMemoPayMeans,
          modelFields: CreditMemoPayMeansFields.values,
        );

  @override
  Future<CreditMemoPayMeansModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? CreditMemoPayMeansModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<CreditMemoPayMeansModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => CreditMemoPayMeansModel.fromMap(itemData))
        .toList();
  }
}
