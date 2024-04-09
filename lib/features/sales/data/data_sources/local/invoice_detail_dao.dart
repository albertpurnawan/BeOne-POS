import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/invoice_detail.dart';
import 'package:sqflite/sqflite.dart';

class InvoiceDetailDao extends BaseDao<InvoiceDetailModel> {
  InvoiceDetailDao(Database db)
      : super(
          db: db,
          tableName: tableInvoiceDetail,
          modelFields: InvoiceDetailFields.values,
        );

  @override
  Future<InvoiceDetailModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? InvoiceDetailModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<InvoiceDetailModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => InvoiceDetailModel.fromMap(itemData))
        .toList();
  }

  Future<List<InvoiceDetailModel>> readByToinvId(
      String toinvId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(
      tableName,
      where: 'toinvId = ?',
      whereArgs: [toinvId],
    );

    return result
        .map((itemData) => InvoiceDetailModel.fromMap(itemData))
        .toList();
  }
}
