import 'dart:developer';

import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/invoice_applied_promo.dart';
import 'package:sqflite/sqflite.dart';

class InvoiceAppliedPromoDao extends BaseDao<InvoiceAppliedPromoModel> {
  InvoiceAppliedPromoDao(Database db)
      : super(
          db: db,
          tableName: tableInvoiceAppliedPromo,
          modelFields: InvoiceAppliedPromoFields.values,
        );

  @override
  Future<InvoiceAppliedPromoModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? InvoiceAppliedPromoModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<InvoiceAppliedPromoModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => InvoiceAppliedPromoModel.fromMap(itemData)).toList();
  }

  Future<List<InvoiceAppliedPromoModel>> readByToinvIdAndTinv1Id(
      String toinvId, String tinv1Id, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(
      tableName,
      where: 'toinvdocid = ? AND tinv1docid = ?',
      whereArgs: [toinvId, tinv1Id],
    );

    return result.map((itemData) => InvoiceAppliedPromoModel.fromMap(itemData)).toList();
  }

  Future<List<InvoiceAppliedPromoModel>> readByToinvId(String toinvId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(
      tableName,
      where: 'toinvdocid = ? AND promotiontype = \'999\'',
      whereArgs: [toinvId],
    );
    log("RESULT - $result");
    return result.map((itemData) => InvoiceAppliedPromoModel.fromMap(itemData)).toList();
  }

  Future<Map<String, List<Map<String, dynamic>>>> getTableData(String toinvId, DateTime start, DateTime end) async {
    final Map<String, List<Map<String, dynamic>>> data = {};
    final rows = await db.rawQuery('''
      SELECT x0.* FROM $tableName x0
        INNER JOIN toinv x1 ON x0.toinvdocid = x1.docid
        WHERE (x0.createdat BETWEEN ? AND ?) 
        AND x0.toinvdocid = ?
    ''', [start.toString(), end.toString(), toinvId]);
    data[tableName] = rows;

    return data;
  }

  Future<void> deleteArchived(String toinvId, DateTime start, DateTime end) async {
    await db.rawDelete('''
      DELETE FROM $tableName
        WHERE (createdat BETWEEN ? AND ?)
        AND toinvdocid = ?
    ''', [start.toString(), end.toString(), toinvId]);
  }
}
