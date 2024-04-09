import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_coupon_default_valid_days.dart';
import 'package:sqflite/sqflite.dart';

class PromoCouponDefaultValidDaysDao
    extends BaseDao<PromoCouponDefaultValidDaysModel> {
  PromoCouponDefaultValidDaysDao(Database db)
      : super(
          db: db,
          tableName: tablePromoCouponDefaultValidDays,
          modelFields: PromoCouponDefaultValidDaysFields.values,
        );

  @override
  Future<PromoCouponDefaultValidDaysModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoCouponDefaultValidDaysModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoCouponDefaultValidDaysModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoCouponDefaultValidDaysModel.fromMap(itemData))
        .toList();
  }
}
