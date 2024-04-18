import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/batch_invoice.dart';
import 'package:sqflite/sqflite.dart';

class BatchInvoiceDao extends BaseDao<BatchInvoiceModel> {
  BatchInvoiceDao(Database db)
      : super(
          db: db,
          tableName: tableBatchInvoice,
          modelFields: BatchInvoiceFields.values,
        );

  @override
  Future<BatchInvoiceModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? BatchInvoiceModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<BatchInvoiceModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => BatchInvoiceModel.fromMap(itemData))
        .toList();
  }
}
