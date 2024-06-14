import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/queued_invoice_detail.dart';
import 'package:sqflite/sqflite.dart';

class QueuedInvoiceDetailDao extends BaseDao<QueuedInvoiceDetailModel> {
  QueuedInvoiceDetailDao(Database db)
      : super(
          db: db,
          tableName: tableQueuedInvoiceDetail,
          modelFields: QueuedInvoiceDetailFields.values,
        );

  @override
  Future<QueuedInvoiceDetailModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? QueuedInvoiceDetailModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<QueuedInvoiceDetailModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => QueuedInvoiceDetailModel.fromMap(itemData))
        .toList();
  }

  Future<List<QueuedInvoiceDetailModel>> readByToinvId(
      String toinvId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(
      tableName,
      where: 'toinvId = ?',
      whereArgs: [toinvId],
    );

    return result
        .map((itemData) => QueuedInvoiceDetailModel.fromMap(itemData))
        .toList();
  }
}
