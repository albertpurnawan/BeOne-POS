import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_harga_spesial_buy.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PromoHargaSpesialBuyDao extends BaseDao<PromoHargaSpesialBuyModel> {
  PromoHargaSpesialBuyDao(Database db)
      : super(
            db: db,
            tableName: tablePromoHargaSpesialBuy,
            modelFields: PromoHargaSpesialBuyFields.values);

  @override
  Future<PromoHargaSpesialBuyModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoHargaSpesialBuyModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoHargaSpesialBuyModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoHargaSpesialBuyModel.fromMap(itemData))
        .toList();
  }
}
