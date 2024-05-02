import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_item_get_condition.dart';
import 'package:sqflite/sqflite.dart';

class PromoDiskonItemGetConditionDao
    extends BaseDao<PromoDiskonItemGetConditionModel> {
  PromoDiskonItemGetConditionDao(Database db)
      : super(
          db: db,
          tableName: tablePromoDiskonItemGetCondition,
          modelFields: PromoDiskonItemGetConditionFields.values,
        );

  @override
  Future<PromoDiskonItemGetConditionModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoDiskonItemGetConditionModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoDiskonItemGetConditionModel>> readAll(
      {Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result
          .map((itemData) => PromoDiskonItemGetConditionModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(tableName);

      return result
          .map((itemData) => PromoDiskonItemGetConditionModel.fromMap(itemData))
          .toList();
    }
  }
}
