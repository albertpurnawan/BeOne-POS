import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/approval_invoice.dart';
import 'package:sqflite/sqflite.dart';

class ApprovalInvoiceDao extends BaseDao<ApprovalInvoiceModel> {
  ApprovalInvoiceDao(Database db)
      : super(
          db: db,
          tableName: tableApprovalInvoice,
          modelFields: ApprovalInvoiceFields.values,
        );

  @override
  Future<ApprovalInvoiceModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ApprovalInvoiceModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<ApprovalInvoiceModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => ApprovalInvoiceModel.fromMap(itemData)).toList();
  }

  Future<ApprovalInvoiceModel?> readByTousrId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'tousrId = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ApprovalInvoiceModel.fromMap(res[0]) : null;
  }

  Future<List<ApprovalInvoiceModel?>> readByToinvId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'toinvId = ?',
      whereArgs: [docId],
    );

    if (res.isNotEmpty) {
      return res.map((map) => ApprovalInvoiceModel.fromMap(map)).toList();
    } else {
      return [];
    }
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
