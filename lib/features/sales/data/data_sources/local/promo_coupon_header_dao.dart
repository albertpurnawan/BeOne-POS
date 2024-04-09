import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_coupon_header.dart';
import 'package:sqflite/sqflite.dart';

class PromoCouponHeaderDao extends BaseDao<PromoCouponHeaderModel> {
  PromoCouponHeaderDao(Database db)
      : super(
          db: db,
          tableName: tablePromoCouponHeader,
          modelFields: PromoCouponHeaderFields.values,
        );

  @override
  Future<PromoCouponHeaderModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoCouponHeaderModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoCouponHeaderModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoCouponHeaderModel.fromMap(itemData))
        .toList();
  }
}
