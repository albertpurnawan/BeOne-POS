import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_voucher_assign_store.dart';
import 'package:sqflite/sqflite.dart';

class PromoVoucherAssignStoreDao extends BaseDao<PromoVoucherAssignStoreModel> {
  PromoVoucherAssignStoreDao(Database db)
      : super(
          db: db,
          tableName: tablePromoVoucherAssignStore,
          modelFields: PromoVoucherAssignStoreFields.values,
        );

  @override
  Future<PromoVoucherAssignStoreModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoVoucherAssignStoreModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoVoucherAssignStoreModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoVoucherAssignStoreModel.fromMap(itemData))
        .toList();
  }
}