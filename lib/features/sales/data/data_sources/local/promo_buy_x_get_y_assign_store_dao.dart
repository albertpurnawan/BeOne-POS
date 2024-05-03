import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_assign_store.dart';
import 'package:sqflite/sqflite.dart';

class PromoBuyXGetYAssignStoreDao
    extends BaseDao<PromoBuyXGetYAssignStoreModel> {
  PromoBuyXGetYAssignStoreDao(Database db)
      : super(
          db: db,
          tableName: tablePromoBuyXGetYAssignStore,
          modelFields: PromoBuyXGetYAssignStoreFields.values,
        );

  @override
  Future<PromoBuyXGetYAssignStoreModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoBuyXGetYAssignStoreModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoBuyXGetYAssignStoreModel>> readAll(
      {Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result
          .map((itemData) => PromoBuyXGetYAssignStoreModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(tableName);

      return result
          .map((itemData) => PromoBuyXGetYAssignStoreModel.fromMap(itemData))
          .toList();
    }
  }
}
