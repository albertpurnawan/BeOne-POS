import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/queued_invoice_header.dart';
import 'package:sqflite/sqflite.dart';

class QueuedInvoiceHeaderDao extends BaseDao<QueuedInvoiceHeaderModel> {
  QueuedInvoiceHeaderDao(Database db)
      : super(
          db: db,
          tableName: tableQueuedInvoiceHeader,
          modelFields: QueuedInvoiceHeaderFields.values,
        );

  @override
  Future<QueuedInvoiceHeaderModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? QueuedInvoiceHeaderModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<QueuedInvoiceHeaderModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => QueuedInvoiceHeaderModel.fromMap(itemData))
        .toList();
  }

  @override
  Future<QueuedInvoiceHeaderModel?> create(
      {required QueuedInvoiceHeaderModel data, Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.insert(tableName, data.toMap());
    final List<Map<String, Object?>> createdData =
        await dbExecutor.query(tableName, where: "rowid = ?", whereArgs: [res]);

    if (createdData.isNotEmpty) {
      return QueuedInvoiceHeaderModel.fromMap(createdData.first);
    } else {
      return null;
    }
  }

  Future<List<QueuedInvoiceHeaderModel>> readByLastDate() async {
    final res = await db.query(
      tableName,
      orderBy: 'createdat DESC',
      limit: 1,
    );

    return res
        .map((itemData) => QueuedInvoiceHeaderModel.fromMap(itemData))
        .toList();
  }

  Future<void> deleteByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    await dbExecutor.delete(
      tableName,
      where: 'docid = ?',
      whereArgs: [docId],
    );
  }

  Future<void> deleteAllData() async {
    await db.delete(tableName);
  }

  // Future<List<QueuedInvoiceHeaderModel>> readByShift() async {
  //   final prefs = GetIt.instance<SharedPreferences>();
  //   final tcsr1Id = prefs.getString('tcsr1Id');

  //   final res = await db.query(
  //     tableName,
  //     where: 'tcsr1Id LIKE ?',
  //     whereArgs: ['$tcsr1Id%'],
  //   );

  //   if (res.isEmpty) {
  //     return [];
  //   }

  //   final List<QueuedInvoiceHeaderModel> invoices =
  //       res.map((e) => QueuedInvoiceHeaderModel.fromMap(e)).toList();

  //   return invoices;
  // }
}
