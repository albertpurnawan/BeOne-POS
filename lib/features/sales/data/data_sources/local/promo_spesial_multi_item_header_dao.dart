import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_spesial_multi_item_header.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PromoSpesialMultiItemHeaderDao extends BaseDao<PromoSpesialMultiItemHeaderModel> {
  PromoSpesialMultiItemHeaderDao(Database db)
      : super(
          db: db,
          tableName: tablePromoSpesialMultiItemHeader,
          modelFields: PromoSpesialMultiItemHeaderFields.values,
        );

  @override
  Future<PromoSpesialMultiItemHeaderModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoSpesialMultiItemHeaderModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoSpesialMultiItemHeaderModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => PromoSpesialMultiItemHeaderModel.fromMap(itemData)).toList();
  }
}
