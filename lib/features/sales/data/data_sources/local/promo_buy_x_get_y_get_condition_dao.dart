import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_get_condition.dart';
import 'package:sqflite/sqflite.dart';

class PromoBuyXGetYGetConditionDao
    extends BaseDao<PromoBuyXGetYGetConditionModel> {
  PromoBuyXGetYGetConditionDao(Database db)
      : super(
          db: db,
          tableName: tablePromoBuyXGetYGetCondition,
          modelFields: PromoBuyXGetYGetConditionFields.values,
        );

  @override
  Future<PromoBuyXGetYGetConditionModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoBuyXGetYGetConditionModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoBuyXGetYGetConditionModel>> readAll(
      {Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result
          .map((itemData) => PromoBuyXGetYGetConditionModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(tableName);

      return result
          .map((itemData) => PromoBuyXGetYGetConditionModel.fromMap(itemData))
          .toList();
    }
  }

  Future<List<PromoBuyXGetYGetConditionModel>> readByToprbId(
      String toprbId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'toprbId = ?',
      whereArgs: [toprbId],
    );

    return result
        .map((e) => PromoBuyXGetYGetConditionModel.fromMap(e))
        .toList();
  }
}
