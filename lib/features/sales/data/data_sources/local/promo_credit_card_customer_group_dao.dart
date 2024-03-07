import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_credit_card_customer_group.dart';
import 'package:sqflite/sqflite.dart';

class PromoCreditCardCustomerGroupDao
    extends BaseDao<PromoCreditCardCustomerGroupModel> {
  PromoCreditCardCustomerGroupDao(Database db)
      : super(
          db: db,
          tableName: tablePromoCreditCardCustomerGroup,
          modelFields: PromoCreditCardCustomerGroupFields.values,
        );

  @override
  Future<PromoCreditCardCustomerGroupModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoCreditCardCustomerGroupModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoCreditCardCustomerGroupModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoCreditCardCustomerGroupModel.fromMap(itemData))
        .toList();
  }
}
