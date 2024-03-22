import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_header.dart';
import 'package:sqflite/sqflite.dart';

class PromoBuyXGetYHeaderDao extends BaseDao<PromoBuyXGetYHeaderModel> {
  PromoBuyXGetYHeaderDao(Database db)
      : super(
          db: db,
          tableName: tablePromoBuyXGetYHeader,
          modelFields: PromoBuyXGetYHeaderFields.values,
        );

  @override
  Future<PromoBuyXGetYHeaderModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoBuyXGetYHeaderModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoBuyXGetYHeaderModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoBuyXGetYHeaderModel.fromMap(itemData))
        .toList();
  }
}