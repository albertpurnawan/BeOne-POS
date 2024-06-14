import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_harga_spesial_assign_store.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PromoHargaSpesialAssignStoreDao
    extends BaseDao<PromoHargaSpesialAssignStoreModel> {
  PromoHargaSpesialAssignStoreDao(Database db)
      : super(
            db: db,
            tableName: tablePromoHargaSpesialAssignStore,
            modelFields: PromoHargaSpesialAssignStoreFields.values);

  @override
  Future<PromoHargaSpesialAssignStoreModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoHargaSpesialAssignStoreModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoHargaSpesialAssignStoreModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => PromoHargaSpesialAssignStoreModel.fromMap(itemData))
        .toList();
  }

  Future<PromoHargaSpesialAssignStoreModel> readByTopsbId(
      String topsbId, Transaction? txn) async {
    if (txn != null) {
      final result = await txn.query(
        tableName,
        columns: modelFields,
        where: 'topsbId = ?',
        whereArgs: [topsbId],
      );

      return PromoHargaSpesialAssignStoreModel.fromMap(result.first);
    } else {
      final result = await db.query(
        tableName,
        columns: modelFields,
        where: 'topsbId = ?',
        whereArgs: [topsbId],
      );

      return PromoHargaSpesialAssignStoreModel.fromMap(result.first);
    }
  }
}
