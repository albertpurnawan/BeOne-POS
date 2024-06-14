import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_bonus_multi_item_get_condition.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PromoMultiItemGetConditionDao
    extends BaseDao<PromoBonusMultiItemGetConditionModel> {
  PromoMultiItemGetConditionDao(Database db)
      : super(
            db: db,
            tableName: tablePromoBonusMultiItemGetCondition,
            modelFields: PromoBonusMultiItemGetConditionFields.values);

  @override
  Future<PromoBonusMultiItemGetConditionModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoBonusMultiItemGetConditionModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoBonusMultiItemGetConditionModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) =>
            PromoBonusMultiItemGetConditionModel.fromMap(itemData))
        .toList();
  }
}
