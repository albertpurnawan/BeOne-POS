import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_gwp_valid_days.dart';
import 'package:sqflite/sqflite.dart';

class PromoGWPValidDaysDao extends BaseDao<PromoGWPValidDaysModel> {
  PromoGWPValidDaysDao(Database db)
      : super(
          db: db,
          tableName: tablePromoGWPValidDays,
          modelFields: PromoGWPValidDaysFields.values,
        );

  @override
  Future<PromoGWPValidDaysModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoGWPValidDaysModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoGWPValidDaysModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoGWPValidDaysModel.fromMap(itemData))
        .toList();
  }
}
