import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_gwp_default_valid_days.dart';
import 'package:sqflite/sqflite.dart';

class PromoGWPDefaultValidDaysDao
    extends BaseDao<PromoGWPDefaultValidDaysModel> {
  PromoGWPDefaultValidDaysDao(Database db)
      : super(
          db: db,
          tableName: tablePromoGWPDefaultValidDays,
          modelFields: PromoGWPDefaultValidDaysFields.values,
        );

  @override
  Future<PromoGWPDefaultValidDaysModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoGWPDefaultValidDaysModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoGWPDefaultValidDaysModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoGWPDefaultValidDaysModel.fromMap(itemData))
        .toList();
  }
}