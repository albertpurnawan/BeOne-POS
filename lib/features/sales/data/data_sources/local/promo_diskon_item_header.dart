import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_item_header.dart';
import 'package:sqflite/sqflite.dart';

class PromoDiskonItemHeaderDao extends BaseDao<PromoDiskonItemHeaderModel> {
  PromoDiskonItemHeaderDao(Database db)
      : super(
          db: db,
          tableName: tablePromoDiskonItemHeader,
          modelFields: PromoDiskonItemHeaderFields.values,
        );

  @override
  Future<PromoDiskonItemHeaderModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoDiskonItemHeaderModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoDiskonItemHeaderModel>> readAll({Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result.map((itemData) => PromoDiskonItemHeaderModel.fromMap(itemData)).toList();
    } else {
      final result = await db.query(tableName);

      return result.map((itemData) => PromoDiskonItemHeaderModel.fromMap(itemData)).toList();
    }
  }
}
