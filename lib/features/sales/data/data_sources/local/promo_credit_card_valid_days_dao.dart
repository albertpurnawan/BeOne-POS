import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_credit_card_valid_days.dart';
import 'package:sqflite/sqflite.dart';

class PromoCreditCardValidDaysDao
    extends BaseDao<PromoCreditCardValidDaysModel> {
  PromoCreditCardValidDaysDao(Database db)
      : super(
          db: db,
          tableName: tablePromoCreditCardValidDays,
          modelFields: PromoCreditCardValidDaysFields.values,
        );

  @override
  Future<PromoCreditCardValidDaysModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoCreditCardValidDaysModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoCreditCardValidDaysModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoCreditCardValidDaysModel.fromMap(itemData))
        .toList();
  }
}
