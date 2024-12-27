import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promotions.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PromosDao extends BaseDao<PromotionsModel> {
  PromosDao(Database db)
      : super(
          db: db,
          tableName: tablePromotions,
          modelFields: PromotionsFields.values,
        );

  @override
  Future<PromotionsModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromotionsModel.fromMap(res[0]) : null;
  }

  Future<PromotionsModel?> readByPromoIdAndPromoType(String promoId, int promoType, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'promoId = ? AND promotype = ?',
      whereArgs: [promoId, promoType],
    );

    return res.isNotEmpty ? PromotionsModel.fromMap(res[0]) : null;
  }

  Future<PromotionsModel?> readByToitmAndPromoType(String toitmId, int promoType, Transaction? txn) async {
    final res = await db.rawQuery('''
      SELECT x0.* FROM toprm AS x0
        INNER JOIN topsb AS X1 ON X0.promoId = x1.docid
        WHERE x1.toitmId = ?
          AND x0.promotype = ?
        ORDER BY x1.createdate DESC
        LIMIT 1
    ''', [toitmId, promoType]);
    return res.isNotEmpty ? PromotionsModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromotionsModel>> readAll({Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result.map((itemData) => PromotionsModel.fromMap(itemData)).toList();
    } else {
      final result = await db.query(tableName);

      return result.map((itemData) => PromotionsModel.fromMap(itemData)).toList();
    }
  }

  Future<void> deletePromos() async {
    await db.delete('toprm');
  }

  Future<List<PromotionsModel>> readByToitmId(String toitmId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    if (txn != null) {
      final res = await dbExecutor.query(
        tableName,
        columns: modelFields,
        where: 'toitmId = ?',
        whereArgs: [toitmId],
      );

      return res.map((itemData) => PromotionsModel.fromMap(itemData)).toList();
    } else {
      final res = await dbExecutor.query(
        tableName,
        columns: modelFields,
        where: 'toitmId = ?',
        whereArgs: [toitmId],
      );

      return res.map((itemData) => PromotionsModel.fromMap(itemData)).toList();
    }
  }
}
