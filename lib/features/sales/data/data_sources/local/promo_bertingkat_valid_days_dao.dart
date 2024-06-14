import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_bertingkat_valid_days.dart';
import 'package:sqflite/sqflite.dart';

class PromoBertingkatValidDaysDao
    extends BaseDao<PromoBertingkatValidDaysModel> {
  PromoBertingkatValidDaysDao(Database db)
      : super(
          db: db,
          tableName: tablePromoBertingkatValidDays,
          modelFields: PromoBertingkatValidDaysFields.values,
        );

  @override
  Future<PromoBertingkatValidDaysModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoBertingkatValidDaysModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoBertingkatValidDaysModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => PromoBertingkatValidDaysModel.fromMap(itemData))
        .toList();
  }
}
