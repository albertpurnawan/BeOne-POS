import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_bertingkat_default_valid_days.dart';
import 'package:sqflite/sqflite.dart';

class PromoBertingkatDefaultValidDaysDao
    extends BaseDao<PromoBertingkatDefaultValidDaysModel> {
  PromoBertingkatDefaultValidDaysDao(Database db)
      : super(
          db: db,
          tableName: tablePromoBertingkatDefaulValidDays,
          modelFields: PromoBertingkatDefaultValidDaysFields.values,
        );

  @override
  Future<PromoBertingkatDefaultValidDaysModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;

    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoBertingkatDefaultValidDaysModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoBertingkatDefaultValidDaysModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) =>
            PromoBertingkatDefaultValidDaysModel.fromMap(itemData))
        .toList();
  }
}
