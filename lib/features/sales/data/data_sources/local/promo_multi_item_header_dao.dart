import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_bonus_multi_item_header.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PromoMultiItemHeaderDao extends BaseDao<PromoBonusMultiItemHeaderModel> {
  PromoMultiItemHeaderDao(Database db)
      : super(
            db: db,
            tableName: tablePromoBonusMultiItemHeader,
            modelFields: PromoBonusMultiItemHeaderFields.values);

  @override
  Future<PromoBonusMultiItemHeaderModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoBonusMultiItemHeaderModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoBonusMultiItemHeaderModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => PromoBonusMultiItemHeaderModel.fromMap(itemData))
        .toList();
  }
}
