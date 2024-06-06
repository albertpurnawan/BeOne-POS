import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/mop_adjustment_detail.dart';
import 'package:sqflite/sqflite.dart';

class MOPAdjustmentDetailDao extends BaseDao<MOPAdjustmentDetailModel> {
  MOPAdjustmentDetailDao(Database db)
      : super(
          db: db,
          tableName: tableMOPAdjustmentDetail,
          modelFields: MOPAdjustmentDetailFields.values,
        );

  @override
  Future<MOPAdjustmentDetailModel?> readByDocId(
      String docId, Transaction? txn) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? MOPAdjustmentDetailModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<MOPAdjustmentDetailModel>> readAll({Transaction? txn}) async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => MOPAdjustmentDetailModel.fromMap(itemData))
        .toList();
  }
}
