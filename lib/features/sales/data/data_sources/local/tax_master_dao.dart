import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/tax_master.dart';
import 'package:sqflite/sqflite.dart';

class TaxMasterDao extends BaseDao<TaxMasterModel> {
  TaxMasterDao(Database db)
      : super(
            db: db,
            tableName: tableTaxMasters,
            modelFields: TaxMasterFields.values);

  @override
  Future<TaxMasterModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? TaxMasterModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<TaxMasterModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => TaxMasterModel.fromMap(itemData)).toList();
  }
}
