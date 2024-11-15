import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_coupon_assign_store.dart';
import 'package:sqflite/sqflite.dart';

class PromoCouponAssignStoreDao extends BaseDao<PromoCouponAssignStoreModel> {
  PromoCouponAssignStoreDao(Database db)
      : super(
          db: db,
          tableName: tablePromoCouponAssignStore,
          modelFields: PromoCouponAssignStoreFields.values,
        );

  @override
  Future<PromoCouponAssignStoreModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoCouponAssignStoreModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoCouponAssignStoreModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => PromoCouponAssignStoreModel.fromMap(itemData)).toList();
  }

  Future<PromoCouponAssignStoreModel?> readByToprnId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'toprnId = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoCouponAssignStoreModel.fromMap(res[0]) : null;
  }
}
