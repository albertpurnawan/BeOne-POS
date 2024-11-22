import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_harga_spesial_header.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PromoHargaSpesialHeaderDao extends BaseDao<PromoHargaSpesialHeaderModel> {
  PromoHargaSpesialHeaderDao(Database db)
      : super(db: db, tableName: tablePromoHargaSpecialHeader, modelFields: PromoHargaSpesialHeaderFields.values);

  @override
  Future<PromoHargaSpesialHeaderModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoHargaSpesialHeaderModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoHargaSpesialHeaderModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => PromoHargaSpesialHeaderModel.fromMap(itemData)).toList();
  }

  Future<PromoHargaSpesialHeaderModel?> readByToitmId(String toitmId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'toitmId = ?',
      whereArgs: [toitmId],
    );

    return res.isNotEmpty ? PromoHargaSpesialHeaderModel.fromMap(res[0]) : null;
  }
}
