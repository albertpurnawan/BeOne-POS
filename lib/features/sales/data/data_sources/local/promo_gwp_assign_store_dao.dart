import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_gwp_assign_store.dart';
import 'package:sqflite/sqflite.dart';

class PromoGWPAssignStoreDao extends BaseDao<PromoGWPAssignStoreModel> {
  PromoGWPAssignStoreDao(Database db)
      : super(
          db: db,
          tableName: tablePromoGWPAssignStore,
          modelFields: PromoGWPAssignStoreFields.values,
        );

  @override
  Future<PromoGWPAssignStoreModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoGWPAssignStoreModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoGWPAssignStoreModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoGWPAssignStoreModel.fromMap(itemData))
        .toList();
  }
}