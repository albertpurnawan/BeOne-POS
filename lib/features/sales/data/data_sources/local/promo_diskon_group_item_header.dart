import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_group_item_header.dart';
import 'package:sqflite/sqflite.dart';

class PromoDiskonGroupItemHeaderDao
    extends BaseDao<PromoDiskonGroupItemHeaderModel> {
  PromoDiskonGroupItemHeaderDao(Database db)
      : super(
          db: db,
          tableName: tablePromoDiskonGroupItemHeader,
          modelFields: PromoDiskonGroupItemHeaderFields.values,
        );

  @override
  Future<PromoDiskonGroupItemHeaderModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoDiskonGroupItemHeaderModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoDiskonGroupItemHeaderModel>> readAll(
      {Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result
          .map((itemData) => PromoDiskonGroupItemHeaderModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(tableName);

      return result
          .map((itemData) => PromoDiskonGroupItemHeaderModel.fromMap(itemData))
          .toList();
    }
  }
}
