import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_group_item_get_condition.dart';
import 'package:sqflite/sqflite.dart';

class PromoDiskonGroupItemGetConditionDao
    extends BaseDao<PromoDiskonGroupItemGetConditionModel> {
  PromoDiskonGroupItemGetConditionDao(Database db)
      : super(
          db: db,
          tableName: tablePromoDiskonGroupItemGetCondition,
          modelFields: PromoDiskonGroupItemGetConditionFields.values,
        );

  @override
  Future<PromoDiskonGroupItemGetConditionModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoDiskonGroupItemGetConditionModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoDiskonGroupItemGetConditionModel>> readAll(
      {Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result
          .map((itemData) =>
              PromoDiskonGroupItemGetConditionModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(tableName);

      return result
          .map((itemData) =>
              PromoDiskonGroupItemGetConditionModel.fromMap(itemData))
          .toList();
    }
  }
}