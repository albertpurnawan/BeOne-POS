import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/holiday.dart';
import 'package:sqflite/sqflite.dart';

class HolidayDao extends BaseDao<HolidayModel> {
  HolidayDao(Database db)
      : super(
          db: db,
          tableName: tableHoliday,
          modelFields: HolidayFields.values,
        );

  @override
  Future<HolidayModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? HolidayModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<HolidayModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => HolidayModel.fromMap(itemData)).toList();
  }
}