import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_package_buy.dart';
import 'package:sqflite/sqflite.dart';

class PromoPackageBuyDao extends BaseDao<PromoPackageBuyModel> {
  PromoPackageBuyDao(Database db)
      : super(
          db: db,
          tableName: tablePromoPackageBuy,
          modelFields: PromoPackageBuyFields.values,
        );

  @override
  Future<PromoPackageBuyModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoPackageBuyModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoPackageBuyModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoPackageBuyModel.fromMap(itemData))
        .toList();
  }
}
