import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/means_of_payment.dart';
import 'package:sqflite/sqflite.dart';

class MeansOfPaymentDao extends BaseDao<MeansOfPaymentModel> {
  MeansOfPaymentDao(Database db)
      : super(
          db: db,
          tableName: tableMOP,
          modelFields: MeansOfPaymentFields.values,
        );

  @override
  Future<MeansOfPaymentModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? MeansOfPaymentModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<MeansOfPaymentModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => MeansOfPaymentModel.fromMap(itemData))
        .toList();
  }

  Future<List<dynamic>?> readByTpmt1BetweenDate(
      DateTime start, DateTime end) async {
    final startDate = start.toUtc().toIso8601String();
    final endDate = end.toUtc().toIso8601String();

    final result = await db.rawQuery('''
      SELECT x0.tpmt1Id, x1.mopcode, x1.description,
      FROM $tableName AS x0
      INNER JOIN tpmt1 AS x1 ON x0.tpmt1Id = x1.docid
      WHERE x0.createdat BETWEEN ? AND ?
      GROUP BY x0.tpmt1Id
    ''', [startDate, endDate]);

    return result;
  }
}
