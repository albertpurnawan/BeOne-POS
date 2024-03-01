import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/pricelist.dart';
import 'package:sqflite/sqflite.dart';

class PricelistDao extends BaseDao<PricelistModel> {
  PricelistDao(Database db)
      : super(
            db: db,
            tableName: tablePricelists,
            modelFields: PricelistFields.values);

  @override
  Future<PricelistModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PricelistModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PricelistModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => PricelistModel.fromMap(itemData)).toList();
  }
}
