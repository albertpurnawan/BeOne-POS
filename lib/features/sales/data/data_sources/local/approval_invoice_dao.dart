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
}
