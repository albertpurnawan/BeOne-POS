import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/pay_means.dart';
import 'package:sqflite/sqflite.dart';

class PayMeansDao extends BaseDao<PayMeansModel> {
  PayMeansDao(Database db)
      : super(
          db: db,
          tableName: tablePayMeans,
          modelFields: PayMeansFields.values,
        );

  @override
  Future<PayMeansModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PayMeansModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PayMeansModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result.map((itemData) => PayMeansModel.fromMap(itemData)).toList();
  }

  Future<List<PayMeansModel>> readByToinvId(
      String toinvId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(
      tableName,
      where: 'toinvId = ?',
      whereArgs: [toinvId],
    );

    return result.map((itemData) => PayMeansModel.fromMap(itemData)).toList();
  }

  Future<List<PayMeansModel>?> readBetweenDate(
      DateTime start, DateTime end) async {
    final result = await db.query(
      tableName,
      where: 'createdat BETWEEN ? AND ?',
      whereArgs: [
        start.toUtc().toIso8601String(),
        end.toUtc().toIso8601String()
      ],
    );
    final transactions =
        result.map((map) => PayMeansModel.fromMap(map)).toList();

    return transactions;
  }
}
