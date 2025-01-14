import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_bonus_multi_item_assign_store.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PromoMultiItemAssignStoreDao extends BaseDao<PromoBonusMultiItemAssignStoreModel> {
  PromoMultiItemAssignStoreDao(Database db)
      : super(
            db: db,
            tableName: tablePromoBonusMultiItemAssignStore,
            modelFields: PromoBonusMultiItemAssignStoreFields.values);

  @override
  Future<PromoBonusMultiItemAssignStoreModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoBonusMultiItemAssignStoreModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoBonusMultiItemAssignStoreModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => PromoBonusMultiItemAssignStoreModel.fromMap(itemData)).toList();
  }

  Future<PromoBonusMultiItemAssignStoreModel?> readByTopmiId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'topmiId = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoBonusMultiItemAssignStoreModel.fromMap(res[0]) : null;
  }
}
