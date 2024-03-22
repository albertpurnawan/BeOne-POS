import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/province.dart';
import 'package:sqflite/sqflite.dart';

class ProvinceDao extends BaseDao<ProvinceModel> {
  ProvinceDao(Database db)
      : super(
          db: db,
          tableName: tableProvince,
          modelFields: ProvinceFields.values,
        );

  @override
  Future<ProvinceModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ProvinceModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<ProvinceModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => ProvinceModel.fromMap(itemData)).toList();
  }
}