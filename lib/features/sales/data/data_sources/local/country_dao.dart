import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/country.dart';
import 'package:sqflite/sqflite.dart';

class CountryDao extends BaseDao<CountryModel> {
  CountryDao(Database db)
      : super(
          db: db,
          tableName: tableCountry,
          modelFields: CountryFields.values,
        );

  @override
  Future<CountryModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? CountryModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<CountryModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => CountryModel.fromMap(itemData)).toList();
  }
}
