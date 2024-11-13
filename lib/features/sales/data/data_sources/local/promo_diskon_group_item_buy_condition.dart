import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_group_item_buy_condition.dart';
import 'package:sqflite/sqflite.dart';

class PromoDiskonGroupItemBuyConditionDao extends BaseDao<PromoDiskonGroupItemBuyConditionModel> {
  PromoDiskonGroupItemBuyConditionDao(Database db)
      : super(
          db: db,
          tableName: tablePromoDiskonGroupItemBuyCondition,
          modelFields: PromoDiskonGroupItemBuyConditionFields.values,
        );

  @override
  Future<PromoDiskonGroupItemBuyConditionModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoDiskonGroupItemBuyConditionModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoDiskonGroupItemBuyConditionModel>> readAll({Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result.map((itemData) => PromoDiskonGroupItemBuyConditionModel.fromMap(itemData)).toList();
    } else {
      final result = await db.query(tableName);

      return result.map((itemData) => PromoDiskonGroupItemBuyConditionModel.fromMap(itemData)).toList();
    }
  }

  Future<List<PromoDiskonGroupItemBuyConditionModel>> readByTopdgId(String topdgId, Transaction? txn) async {
    if (txn != null) {
      final result = await txn.query(
        tableName,
        columns: modelFields,
        where: 'topdgId = ?',
        whereArgs: [topdgId],
      );
      return result.map((itemData) => PromoDiskonGroupItemBuyConditionModel.fromMap(itemData)).toList();
    } else {
      final result = await db.query(
        tableName,
        columns: modelFields,
        where: 'topdgId = ?',
        whereArgs: [topdgId],
      );
      return result.map((itemData) => PromoDiskonGroupItemBuyConditionModel.fromMap(itemData)).toList();
    }
  }
}
