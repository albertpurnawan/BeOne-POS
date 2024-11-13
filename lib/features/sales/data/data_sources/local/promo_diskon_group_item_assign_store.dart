import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_group_item_assign_store.dart';
import 'package:sqflite/sqflite.dart';

class PromoDiskonGroupItemAssignStoreDao extends BaseDao<PromoDiskonGroupItemAssignStoreModel> {
  PromoDiskonGroupItemAssignStoreDao(Database db)
      : super(
          db: db,
          tableName: tablePromoDiskonGroupItemAssignStore,
          modelFields: PromoDiskonGroupItemAssignStoreFields.values,
        );

  @override
  Future<PromoDiskonGroupItemAssignStoreModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoDiskonGroupItemAssignStoreModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoDiskonGroupItemAssignStoreModel>> readAll({Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result.map((itemData) => PromoDiskonGroupItemAssignStoreModel.fromMap(itemData)).toList();
    } else {
      final result = await db.query(tableName);

      return result.map((itemData) => PromoDiskonGroupItemAssignStoreModel.fromMap(itemData)).toList();
    }
  }

  Future<PromoDiskonGroupItemAssignStoreModel> readByTodgId(String topdgId, Transaction? txn) async {
    if (txn != null) {
      final result = await txn.query(
        tableName,
        columns: modelFields,
        where: 'topdgId = ?',
        whereArgs: [topdgId],
      );

      return PromoDiskonGroupItemAssignStoreModel.fromMap(result.first);
    } else {
      final result = await db.query(
        tableName,
        columns: modelFields,
        where: 'topdgId = ?',
        whereArgs: [topdgId],
      );

      return PromoDiskonGroupItemAssignStoreModel.fromMap(result.first);
    }
  }

  Future<List<PromoDiskonGroupItemAssignStoreModel>> readByStoreId(String tostrId, Transaction? txn) async {
    final result = txn != null
        ? await txn.query(
            tableName,
            columns: modelFields,
            where: 'tostrId = ?',
            whereArgs: [tostrId],
          )
        : await db.query(
            tableName,
            columns: modelFields,
            where: 'tostrId = ?',
            whereArgs: [tostrId],
          );

    return result.map((item) => PromoDiskonGroupItemAssignStoreModel.fromMap(item)).toList();
  }
}
