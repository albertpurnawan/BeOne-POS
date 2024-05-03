import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_buy_condition.dart';
import 'package:sqflite/sqflite.dart';

class PromoBuyXGetYBuyConditionDao
    extends BaseDao<PromoBuyXGetYBuyConditionModel> {
  PromoBuyXGetYBuyConditionDao(Database db)
      : super(
          db: db,
          tableName: tablePromoBuyXGetYBuyCondition,
          modelFields: PromoBuyXGetYBuyConditionFields.values,
        );

  @override
  Future<PromoBuyXGetYBuyConditionModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoBuyXGetYBuyConditionModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoBuyXGetYBuyConditionModel>> readAll(
      {Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result
          .map((itemData) => PromoBuyXGetYBuyConditionModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(tableName);

      return result
          .map((itemData) => PromoBuyXGetYBuyConditionModel.fromMap(itemData))
          .toList();
    }
  }
}
