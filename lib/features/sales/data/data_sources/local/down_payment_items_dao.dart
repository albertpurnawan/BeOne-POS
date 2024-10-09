import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/down_payment_items_model.dart';
import 'package:sqflite/sqflite.dart';

class DownPaymentItemsDao extends BaseDao<DownPaymentItemsModel> {
  DownPaymentItemsDao(Database db)
      : super(
          db: db,
          tableName: tableDownPaymentItem,
          modelFields: DownPaymentItemsFields.values,
        );

  @override
  Future<DownPaymentItemsModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? DownPaymentItemsModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<DownPaymentItemsModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => DownPaymentItemsModel.fromMap(itemData)).toList();
  }

  Future<List<DownPaymentItemsModel?>> readByToinvId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'toinvId = ?',
      whereArgs: [docId],
    );

    if (res.isNotEmpty) {
      return res.map((map) => DownPaymentItemsModel.fromMap(map)).toList();
    } else {
      return [];
    }
  }
}
