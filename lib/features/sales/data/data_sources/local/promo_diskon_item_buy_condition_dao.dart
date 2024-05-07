import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_item_buy_condition.dart';
import 'package:sqflite/sqflite.dart';

class PromoDiskonItemBuyConditionDao
    extends BaseDao<PromoDiskonItemBuyConditionModel> {
  PromoDiskonItemBuyConditionDao(Database db)
      : super(
          db: db,
          tableName: tablePromoDiskonItemBuyCondition,
          modelFields: PromoDiskonItemBuyConditionFields.values,
        );

  @override
  Future<PromoDiskonItemBuyConditionModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoDiskonItemBuyConditionModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoDiskonItemBuyConditionModel>> readAll(
      {Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result
          .map((itemData) => PromoDiskonItemBuyConditionModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(tableName);

      return result
          .map((itemData) => PromoDiskonItemBuyConditionModel.fromMap(itemData))
          .toList();
    }
  }

  Future<List<PromoDiskonItemBuyConditionModel>> readByTopdiId(
      String topdiId, Transaction? txn) async {
    if (txn != null) {
      final result = await txn.query(
        tableName,
        columns: modelFields,
        where: 'topdiId = ?',
        whereArgs: [topdiId],
      );
      return result
          .map((itemData) => PromoDiskonItemBuyConditionModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(
        tableName,
        columns: modelFields,
        where: 'topdiId = ?',
        whereArgs: [topdiId],
      );
      return result
          .map((itemData) => PromoDiskonItemBuyConditionModel.fromMap(itemData))
          .toList();
    }
  }
}
