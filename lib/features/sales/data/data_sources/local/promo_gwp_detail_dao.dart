import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_gwp_detail.dart';
import 'package:sqflite/sqflite.dart';

class PromoGWPDetailDao extends BaseDao<PromoGWPDetailModel> {
  PromoGWPDetailDao(Database db)
      : super(
          db: db,
          tableName: tablePromoGWPDetail,
          modelFields: PromoGWPDetailFields.values,
        );

  @override
  Future<PromoGWPDetailModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoGWPDetailModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoGWPDetailModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoGWPDetailModel.fromMap(itemData))
        .toList();
  }
}
