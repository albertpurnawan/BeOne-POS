import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_item_assign_store.dart';
import 'package:sqflite/sqflite.dart';

class PromoDiskonItemAssignStoreDao
    extends BaseDao<PromoDiskonItemAssignStoreModel> {
  PromoDiskonItemAssignStoreDao(Database db)
      : super(
          db: db,
          tableName: tablePromoDiskonItemAssignStore,
          modelFields: PromoDiskonItemAssignStoreFields.values,
        );

  @override
  Future<PromoDiskonItemAssignStoreModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoDiskonItemAssignStoreModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoDiskonItemAssignStoreModel>> readAll(
      {Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result
          .map((itemData) => PromoDiskonItemAssignStoreModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(tableName);

      return result
          .map((itemData) => PromoDiskonItemAssignStoreModel.fromMap(itemData))
          .toList();
    }
  }
}
