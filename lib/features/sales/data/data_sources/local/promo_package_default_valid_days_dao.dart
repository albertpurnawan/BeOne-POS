import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_package_default_valid_days.dart';
import 'package:sqflite/sqflite.dart';

class PromoPackageDefaultValidDaysDao
    extends BaseDao<PromoPackageDefaultValidDaysModel> {
  PromoPackageDefaultValidDaysDao(Database db)
      : super(
          db: db,
          tableName: tablePromoPackageDefaultValidDays,
          modelFields: PromoPackageDefaultValidDaysFields.values,
        );

  @override
  Future<PromoPackageDefaultValidDaysModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoPackageDefaultValidDaysModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoPackageDefaultValidDaysModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoPackageDefaultValidDaysModel.fromMap(itemData))
        .toList();
  }
}
