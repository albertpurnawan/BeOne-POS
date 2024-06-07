import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/mop_adjustment_header.dart';
import 'package:sqflite/sqflite.dart';

class MOPAdjustmentHeaderDao extends BaseDao<MOPAdjustmentHeaderModel> {
  MOPAdjustmentHeaderDao(Database db)
      : super(
          db: db,
          tableName: tableMOPAdjustmentHeader,
          modelFields: MOPAdjustmentHeaderFields.values,
        );

  @override
  Future<MOPAdjustmentHeaderModel?> readByDocId(
      String docId, Transaction? txn) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? MOPAdjustmentHeaderModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<MOPAdjustmentHeaderModel>> readAll({Transaction? txn}) async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => MOPAdjustmentHeaderModel.fromMap(itemData))
        .toList();
  }
}
