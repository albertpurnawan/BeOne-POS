import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_default_valid_days.dart';
import 'package:sqflite/sqflite.dart';

class PromoBuyXGetYDefaultValidDaysDao
    extends BaseDao<PromoBuyXGetYDefaultValidDaysModel> {
  PromoBuyXGetYDefaultValidDaysDao(Database db)
      : super(
          db: db,
          tableName: tablePromoBuyXGetYDefaultValidDays,
          modelFields: PromoBuyXGetYDefaultValidDaysFields.values,
        );

  @override
  Future<PromoBuyXGetYDefaultValidDaysModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoBuyXGetYDefaultValidDaysModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoBuyXGetYDefaultValidDaysModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoBuyXGetYDefaultValidDaysModel.fromMap(itemData))
        .toList();
  }
}
