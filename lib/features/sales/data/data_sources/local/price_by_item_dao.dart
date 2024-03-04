import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/price_by_item.dart';
import 'package:sqflite/sqflite.dart';

class PriceByItemDao extends BaseDao<PriceByItemModel> {
  PriceByItemDao(Database db)
      : super(
            db: db,
            tableName: tablePricesByItem,
            modelFields: PriceByItemFields.values);

  @override
  Future<PriceByItemModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PriceByItemModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PriceByItemModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PriceByItemModel.fromMap(itemData))
        .toList();
  }
}