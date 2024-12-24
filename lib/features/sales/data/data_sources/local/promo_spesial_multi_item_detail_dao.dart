import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_spesial_multi_item_detail.dart';
import 'package:sqflite/sqflite.dart';

class PromoSpesialMultiItemDetailDao extends BaseDao<PromoSpesialMultiItemDetailModel> {
  PromoSpesialMultiItemDetailDao(Database db)
      : super(
          db: db,
          tableName: tablePromoSpesialMultiItemDetail,
          modelFields: PromoSpesialMultiItemDetailFields.values,
        );

  @override
  Future<PromoSpesialMultiItemDetailModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoSpesialMultiItemDetailModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoSpesialMultiItemDetailModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => PromoSpesialMultiItemDetailModel.fromMap(itemData)).toList();
  }

  Future<PromoSpesialMultiItemDetailModel> readByTopsmId(String topsmId, Transaction? txn) async {
    if (txn != null) {
      final result = await txn.query(
        tableName,
        columns: modelFields,
        where: 'topsmId = ?',
        whereArgs: [topsmId],
      );

      return PromoSpesialMultiItemDetailModel.fromMap(result.first);
    } else {
      final result = await db.query(
        tableName,
        columns: modelFields,
        where: 'topsmId = ?',
        whereArgs: [topsmId],
      );

      return PromoSpesialMultiItemDetailModel.fromMap(result.first);
    }
  }

  Future<List<PromoSpesialMultiItemDetailModel>> readAllByTopsmId(String topsmId, Transaction? txn) async {
    List<Map<String, dynamic>> result;

    if (txn != null) {
      result = await txn.query(
        tableName,
        columns: modelFields,
        where: 'topsmId = ?',
        whereArgs: [topsmId],
      );
    } else {
      result = await db.query(
        tableName,
        columns: modelFields,
        where: 'topsmId = ?',
        whereArgs: [topsmId],
      );
    }

    return result.map((map) => PromoSpesialMultiItemDetailModel.fromMap(map)).toList();
  }
}
