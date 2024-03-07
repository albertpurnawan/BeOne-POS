import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_voucher_header.dart';
import 'package:sqflite/sqflite.dart';

class PromoVoucherHeaderDao extends BaseDao<PromoVoucherHeaderModel> {
  PromoVoucherHeaderDao(Database db)
      : super(
          db: db,
          tableName: tablePromoVoucherHeader,
          modelFields: PromoVoucherHeaderFields.values,
        );

  @override
  Future<PromoVoucherHeaderModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoVoucherHeaderModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoVoucherHeaderModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoVoucherHeaderModel.fromMap(itemData))
        .toList();
  }
}
