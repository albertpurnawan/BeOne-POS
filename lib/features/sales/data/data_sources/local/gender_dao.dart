import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/gender.dart';
import 'package:sqflite/sqflite.dart';

class GenderDao extends BaseDao<GenderModel> {
  GenderDao(Database db)
      : super(
          db: db,
          tableName: tableGender,
          modelFields: GenderFields.values,
        );

  @override
  Future<GenderModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? GenderModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<GenderModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => GenderModel.fromMap(itemData)).toList();
  }
}
