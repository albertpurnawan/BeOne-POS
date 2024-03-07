import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_customer_group.dart';
import 'package:sqflite/sqflite.dart';

class PromoBuyXGetYCustomerGroupDao
    extends BaseDao<PromoBuyXGetYCustomerGroupModel> {
  PromoBuyXGetYCustomerGroupDao(Database db)
      : super(
          db: db,
          tableName: tablePromoBuyXGetYCustomerGroup,
          modelFields: PromoBuyXGetYCustomerGroupFields.values,
        );

  @override
  Future<PromoBuyXGetYCustomerGroupModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoBuyXGetYCustomerGroupModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoBuyXGetYCustomerGroupModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoBuyXGetYCustomerGroupModel.fromMap(itemData))
        .toList();
  }
}
