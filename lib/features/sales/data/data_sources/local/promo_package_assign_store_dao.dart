import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_package_assign_store.dart';
import 'package:sqflite/sqflite.dart';

class PromoPackageAssignStoreDao extends BaseDao<PromoPackageAssignStoreModel> {
  PromoPackageAssignStoreDao(Database db)
      : super(
          db: db,
          tableName: tablePromoPackageAssignStore,
          modelFields: PromoPackageAssignStoreFields.values,
        );

  @override
  Future<PromoPackageAssignStoreModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoPackageAssignStoreModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoPackageAssignStoreModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoPackageAssignStoreModel.fromMap(itemData))
        .toList();
  }
}
