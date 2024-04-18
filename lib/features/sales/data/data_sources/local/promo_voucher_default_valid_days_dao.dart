import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_voucher_default_valid_days.dart';
import 'package:sqflite/sqflite.dart';

class PromoVoucherDefaultValidDaysDao
    extends BaseDao<PromoVoucherDefaultValidDaysModel> {
  PromoVoucherDefaultValidDaysDao(Database db)
      : super(
          db: db,
          tableName: tablePromoVoucherDefaultValidDays,
          modelFields: PromoVoucherDefaultValidDaysFields.values,
        );

  @override
  Future<PromoVoucherDefaultValidDaysModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoVoucherDefaultValidDaysModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoVoucherDefaultValidDaysModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoVoucherDefaultValidDaysModel.fromMap(itemData))
        .toList();
  }
}
