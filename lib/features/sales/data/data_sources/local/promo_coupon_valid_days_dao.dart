import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_coupon_valid_days.dart';
import 'package:sqflite/sqflite.dart';

class PromoCouponAssignStoreDap extends BaseDao<PromoCouponValidDaysModel> {
  PromoCouponAssignStoreDap(Database db)
      : super(
          db: db,
          tableName: tablePromoCouponValidDays,
          modelFields: PromoCouponValidDaysFields.values,
        );

  @override
  Future<PromoCouponValidDaysModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoCouponValidDaysModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoCouponValidDaysModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoCouponValidDaysModel.fromMap(itemData))
        .toList();
  }
}