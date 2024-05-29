import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/settings/data/models/receipt_content.dart';
import 'package:sqflite/sqflite.dart';

class ReceiptContentDao extends BaseDao<ReceiptContentModel> {
  ReceiptContentDao(Database db)
      : super(
          db: db,
          tableName: tableReceiptContents,
          modelFields: ReceiptContentFields.values,
        );

  @override
  Future<ReceiptContentModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ReceiptContentModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<ReceiptContentModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => ReceiptContentModel.fromMap(itemData))
        .toList();
  }

  Future<void> deleteAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.delete(tableName);

    return;
  }
}
