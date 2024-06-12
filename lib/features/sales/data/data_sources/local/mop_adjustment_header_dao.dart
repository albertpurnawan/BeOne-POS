import 'package:intl/intl.dart';
import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/mop_adjustment_header.dart';
import 'package:sqflite/sqflite.dart';

class MOPAdjustmentHeaderDao extends BaseDao<MOPAdjustmentHeaderModel> {
  MOPAdjustmentHeaderDao(Database db)
      : super(
          db: db,
          tableName: tableMOPAdjustmentHeader,
          modelFields: MOPAdjustmentHeaderFields.values,
        );

  @override
  Future<MOPAdjustmentHeaderModel?> readByDocId(
      String docId, Transaction? txn) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? MOPAdjustmentHeaderModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<MOPAdjustmentHeaderModel>> readAll({Transaction? txn}) async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => MOPAdjustmentHeaderModel.fromMap(itemData))
        .toList();
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
}
