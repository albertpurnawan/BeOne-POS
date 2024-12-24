import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_spesial_multi_item_assign_store.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PromoSpesialMultiItemAssignStoreDao extends BaseDao<PromoSpesialMultiItemAssignStoreModel> {
  PromoSpesialMultiItemAssignStoreDao(Database db)
      : super(
            db: db,
            tableName: tablePromoSpesialMultiItemAssignStore,
            modelFields: PromoSpesialMultiItemAssignStoreFields.values);

  @override
  Future<PromoSpesialMultiItemAssignStoreModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoSpesialMultiItemAssignStoreModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoSpesialMultiItemAssignStoreModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => PromoSpesialMultiItemAssignStoreModel.fromMap(itemData)).toList();
  }

  Future<PromoSpesialMultiItemAssignStoreModel?> readByTopsmId(String topsmId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'topsmId = ?',
      whereArgs: [topsmId],
    );

    return res.isNotEmpty ? PromoSpesialMultiItemAssignStoreModel.fromMap(res[0]) : null;
  }
}
