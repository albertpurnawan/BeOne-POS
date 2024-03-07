import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_package_header.dart';
import 'package:sqflite/sqflite.dart';

class PromoPackageHeaderDao extends BaseDao<PromoPackageHeaderModel> {
  PromoPackageHeaderDao(Database db)
      : super(
          db: db,
          tableName: tablePromoPackageHeader,
          modelFields: PromoPackageHeaderFields.values,
        );

  @override
  Future<PromoPackageHeaderModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoPackageHeaderModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoPackageHeaderModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoPackageHeaderModel.fromMap(itemData))
        .toList();
  }
}
