import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_bertingkat_default_price_level.dart';
import 'package:sqflite/sqflite.dart';

class PromoBertingkatDefaultPriceLevelDao
    extends BaseDao<PromoBertingkatDefaultPriceLevelModel> {
  PromoBertingkatDefaultPriceLevelDao(Database db)
      : super(
          db: db,
          tableName: tablePromoBertingkatDefaultPriceLevel,
          modelFields: PromoBertingkatDefaultPriceLevelFields.values,
        );

  @override
  Future<PromoBertingkatDefaultPriceLevelModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;

    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoBertingkatDefaultPriceLevelModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoBertingkatDefaultPriceLevelModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) =>
            PromoBertingkatDefaultPriceLevelModel.fromMap(itemData))
        .toList();
  }
}
