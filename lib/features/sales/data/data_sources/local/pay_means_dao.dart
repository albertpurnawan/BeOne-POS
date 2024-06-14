import 'package:intl/intl.dart';
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
    final result = await dbExecutor.query(tableName);

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

  Future<List<dynamic>?> readByTpmt3BetweenDate(
      DateTime start, DateTime end) async {
    final startDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(start);
    final endDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(end);

    final result = await db.rawQuery('''
      SELECT x0.tpmt3Id, x0.amount, SUM(x0.amount) AS totalamount,
      x2.mopcode, x2.description
      FROM $tableName AS x0
      INNER JOIN tpmt3 AS x1 ON x0.tpmt3Id = x1.docid
      INNER JOIN tpmt1 AS x2 ON x1.tpmt1Id = x2.docid
      WHERE x0.createdat BETWEEN ? AND ?
      GROUP BY x0.tpmt3Id
    ''', [startDate, endDate]);

    return result;
  }

  Future<List<dynamic>?> readByToinvShowTopmt(String toinvId) async {
    final result = await db.rawQuery('''
      SELECT x0.*, x3.paytypecode
      FROM tinv2 as x0 
      INNER JOIN tpmt3 as x1 ON x0.tpmt3Id = x1.docid
      INNER JOIN tpmt1 as x2 ON x1.tpmt1Id = x2.docid
      INNER JOIN topmt as x3 ON x2.topmtId = x3.docid
      WHERE x0.toinvId = ?
    ''', [toinvId]);

    return result;
  }
}
