import 'package:intl/intl.dart';
import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/mop_selection.dart';
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

  Future<List<PayMeansModel>> readByToinvId(String toinvId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(
      tableName,
      where: 'toinvId = ?',
      whereArgs: [toinvId],
    );

    return result.map((itemData) => PayMeansModel.fromMap(itemData)).toList();
  }

  Future<List<PayMeansModel>?> readBetweenDate(DateTime start, DateTime end) async {
    final result = await db.query(
      tableName,
      where: 'createdat BETWEEN ? AND ?',
      whereArgs: [start.toUtc().toIso8601String(), end.toUtc().toIso8601String()],
    );
    final transactions = result.map((map) => PayMeansModel.fromMap(map)).toList();

    return transactions;
  }

  Future<List<dynamic>?> readByTpmt3BetweenDate(DateTime start, DateTime end) async {
    final startDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(start);
    final endDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(end);

    final result = await db.rawQuery('''
      SELECT x0.tpmt3Id, x0.amount, SUM(x0.amount) AS totalamount,
      x2.mopcode, x2.description, x1.docid, x3.docid, x3.description AS topmtDesc
      FROM $tableName AS x0
      INNER JOIN tpmt3 AS x1 ON x0.tpmt3Id = x1.docid
      INNER JOIN tpmt1 AS x2 ON x1.tpmt1Id = x2.docid
      INNER JOIN topmt AS x3 ON x2.topmtId = x3.docid
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

  Future<List<MopSelectionModel>> readMopSelectionsByToinvId(String toinvId, txn) async {
    final DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.rawQuery('''
      SELECT x0.docid as tinv2Id, x0.*, x1.docid as tpmt3Id, x3.paytypecode, x3.paytypecode, x3.description, x2.docid as tpmt1Id, x2.mopalias, x2.bankcharge, x2.topmtId, x2.subtype, x5.description as cardname, x4.description as edcdesc, x4.docid as tpmt4Id
      FROM tinv2 as x0 
      INNER JOIN tpmt3 as x1 ON x0.tpmt3Id = x1.docid
      INNER JOIN tpmt1 as x2 ON x1.tpmt1Id = x2.docid
      INNER JOIN topmt as x3 ON x2.topmtId = x3.docid
      INNER JOIN tpmt4 as x4 ON x2.tpmt4Id = x4.docid
      LEFT JOIN tpmt2 as x5 ON x0.tpmt2Id = x5.docid
      WHERE x0.toinvId = ?
    ''', [toinvId]);

    return result.map((itemData) => MopSelectionModel.fromMap(itemData)).toList();
  }

  Future<Map<String, List<Map<String, dynamic>>>> getTableData(String toinvId, DateTime start, DateTime end) async {
    final Map<String, List<Map<String, dynamic>>> data = {};
    final rows = await db.rawQuery('''
      SELECT x0.* FROM $tableName x0
        INNER JOIN toinv x1 ON x0.toinvId = x1.docid
        WHERE (x0.createdat BETWEEN ? AND ?) 
        AND x0.toinvId = ?
    ''', [start.toString(), end.toString(), toinvId]);
    data[tableName] = rows;

    return data;
  }

  Future<void> deleteArchived(String toinvId, DateTime start, DateTime end) async {
    await db.rawDelete('''
      DELETE FROM $tableName
        WHERE (createdat BETWEEN ? AND ?)
        AND toinvId = ?
    ''', [start.toString(), end.toString(), toinvId]);
  }
}
