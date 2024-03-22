import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_credit_card.dart';
import 'package:sqflite/sqflite.dart';

class PromoCreditCardDao extends BaseDao<PromoCreditCardModel> {
  PromoCreditCardDao(Database db)
      : super(
          db: db,
          tableName: tablePromoCreditCard,
          modelFields: PromoCreditCardFields.values,
        );

  @override
  Future<PromoCreditCardModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoCreditCardModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoCreditCardModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoCreditCardModel.fromMap(itemData))
        .toList();
  }
}