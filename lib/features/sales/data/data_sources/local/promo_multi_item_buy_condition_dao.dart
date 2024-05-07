import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_bonus_multi_item_buy_condition.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PromoMultiItemBuyConditionDao
    extends BaseDao<PromoBonusMultiItemBuyConditionModel> {
  PromoMultiItemBuyConditionDao(Database db)
      : super(
            db: db,
            tableName: tablePromoBonusMultiItemBuyCondition,
            modelFields: PromoBonusMultiItemBuyConditionFields.values);

  @override
  Future<PromoBonusMultiItemBuyConditionModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoBonusMultiItemBuyConditionModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoBonusMultiItemBuyConditionModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) =>
            PromoBonusMultiItemBuyConditionModel.fromMap(itemData))
        .toList();
  }

  Future<List<PromoBonusMultiItemBuyConditionModel>> readByTopmiId(
      String topmiid, Transaction? txn) async {
    if (txn != null) {
      final result = await txn.query(
        tableName,
        columns: modelFields,
        where: 'topmiid = ?',
        whereArgs: [topmiid],
      );
      return result
          .map((itemData) =>
              PromoBonusMultiItemBuyConditionModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(
        tableName,
        columns: modelFields,
        where: 'topmiid = ?',
        whereArgs: [topmiid],
      );
      return result
          .map((itemData) =>
              PromoBonusMultiItemBuyConditionModel.fromMap(itemData))
          .toList();
    }
  }
}
