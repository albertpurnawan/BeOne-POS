import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_credit_card_default_valid_days.dart';
import 'package:sqflite/sqflite.dart';

class PromoCreditCardDefaultValidDaysDao
    extends BaseDao<PromoCreditCardDefaultValidDaysModel> {
  PromoCreditCardDefaultValidDaysDao(Database db)
      : super(
          db: db,
          tableName: tablePromoCreditCardDefaultValidDays,
          modelFields: PromoCreditCardDefaultValidDaysFields.values,
        );

  @override
  Future<PromoCreditCardDefaultValidDaysModel?> readByDocId(
      String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoCreditCardDefaultValidDaysModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoCreditCardDefaultValidDaysModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) =>
            PromoCreditCardDefaultValidDaysModel.fromMap(itemData))
        .toList();
  }
}
