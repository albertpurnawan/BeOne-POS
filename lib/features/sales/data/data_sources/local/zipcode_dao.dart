import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/zip_code.dart';
import 'package:sqflite/sqflite.dart';

class ZipcodeDao extends BaseDao<ZipCodeModel> {
  ZipcodeDao(Database db)
      : super(
          db: db,
          tableName: tableZipCode,
          modelFields: ZipCodeFields.values,
        );

  @override
  Future<ZipCodeModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ZipCodeModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<ZipCodeModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => ZipCodeModel.fromMap(itemData)).toList();
  }
}
