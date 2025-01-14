import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_package_valid_days.dart';
import 'package:sqflite/sqflite.dart';

class PromoPackageValidDaysDao extends BaseDao<PromoPackageValidDaysModel> {
  PromoPackageValidDaysDao(Database db)
      : super(
          db: db,
          tableName: tablePromoPackageValidDays,
          modelFields: PromoPackageValidDaysFields.values,
        );

  @override
  Future<PromoPackageValidDaysModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoPackageValidDaysModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoPackageValidDaysModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => PromoPackageValidDaysModel.fromMap(itemData))
        .toList();
  }
}
