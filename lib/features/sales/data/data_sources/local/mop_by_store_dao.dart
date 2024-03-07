import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/mop_by_store.dart';
import 'package:sqflite/sqflite.dart';

class MOPByStoreDao extends BaseDao<MOPByStoreModel> {
  MOPByStoreDao(Database db)
      : super(
          db: db,
          tableName: tableMOPByStore,
          modelFields: MOPByStoreFields.values,
        );

  @override
  Future<MOPByStoreModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? MOPByStoreModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<MOPByStoreModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => MOPByStoreModel.fromMap(itemData)).toList();
  }
}
