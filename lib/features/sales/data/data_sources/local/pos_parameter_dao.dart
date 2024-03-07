import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:sqflite/sqflite.dart';

class POSParameterDao extends BaseDao<POSParameterModel> {
  POSParameterDao(Database db)
      : super(
          db: db,
          tableName: tablePOSParameter,
          modelFields: POSParameterFields.values,
        );

  @override
  Future<POSParameterModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? POSParameterModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<POSParameterModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => POSParameterModel.fromMap(itemData))
        .toList();
  }
}
