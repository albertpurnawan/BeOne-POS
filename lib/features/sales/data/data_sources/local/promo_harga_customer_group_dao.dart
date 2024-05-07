import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_harga_spesial_customer_group.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PromoHargaSpesialCustomerGroupDao
    extends BaseDao<PromoHargaSpesialCustomerGroupModel> {
  PromoHargaSpesialCustomerGroupDao(Database db)
      : super(
            db: db,
            tableName: tablePromoHargaSpesialCustomerGroup,
            modelFields: PromoHargaSpesialCustomerGroupFields.values);

  @override
  Future<PromoHargaSpesialCustomerGroupModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoHargaSpesialCustomerGroupModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoHargaSpesialCustomerGroupModel>> readAll(
      {Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result
          .map((itemData) =>
              PromoHargaSpesialCustomerGroupModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(tableName);

      return result
          .map((itemData) =>
              PromoHargaSpesialCustomerGroupModel.fromMap(itemData))
          .toList();
    }
  }

  Future<List<PromoHargaSpesialCustomerGroupModel>> readByTopsbId(
      String topsbId, Transaction? txn) async {
    if (txn != null) {
      final result = await txn.query(
        tableName,
        columns: modelFields,
        where: 'topsbId = ?',
        whereArgs: [topsbId],
      );
      return result
          .map((itemData) =>
              PromoHargaSpesialCustomerGroupModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(
        tableName,
        columns: modelFields,
        where: 'topsbId = ?',
        whereArgs: [topsbId],
      );
      return result
          .map((itemData) =>
              PromoHargaSpesialCustomerGroupModel.fromMap(itemData))
          .toList();
    }
  }
}
