import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/holiday_detail.dart';
import 'package:sqflite/sqflite.dart';

class HolidayDetailDao extends BaseDao<HolidayDetailModel> {
  HolidayDetailDao(Database db)
      : super(
          db: db,
          tableName: tableHolidayDetail,
          modelFields: HolidayDetailFields.values,
        );

  @override
  Future<HolidayDetailModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? HolidayDetailModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<HolidayDetailModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => HolidayDetailModel.fromMap(itemData))
        .toList();
  }
}
