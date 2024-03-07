import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_voucher_valid_days.dart';
import 'package:sqflite/sqflite.dart';

class PromoVoucherValidDaysDao extends BaseDao<PromoVoucherValidDaysModel> {
  PromoVoucherValidDaysDao(Database db)
      : super(
          db: db,
          tableName: tablePromoVoucherValidDays,
          modelFields: PromoVoucherValidDaysFields.values,
        );

  @override
  Future<PromoVoucherValidDaysModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoVoucherValidDaysModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoVoucherValidDaysModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoVoucherValidDaysModel.fromMap(itemData))
        .toList();
  }
}
