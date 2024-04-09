import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_gwp_header.dart';
import 'package:sqflite/sqflite.dart';

class PromoGWPHeaderDao extends BaseDao<PromoGWPHeaderModel> {
  PromoGWPHeaderDao(Database db)
      : super(
          db: db,
          tableName: tablePromoGWPHeader,
          modelFields: PromoGWPHeaderFields.values,
        );

  @override
  Future<PromoGWPHeaderModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoGWPHeaderModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoGWPHeaderModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoGWPHeaderModel.fromMap(itemData))
        .toList();
  }
}
