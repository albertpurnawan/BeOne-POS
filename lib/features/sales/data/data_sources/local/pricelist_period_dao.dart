import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/pricelist_period.dart';
import 'package:sqflite/sqflite.dart';

class PricelistPeriodDao extends BaseDao<PricelistPeriodModel> {
  PricelistPeriodDao(Database db)
      : super(
            db: db,
            tableName: tablePricelistPeriods,
            modelFields: PricelistPeriodFields.values);

  @override
  Future<PricelistPeriodModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PricelistPeriodModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PricelistPeriodModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => PricelistPeriodModel.fromMap(itemData))
        .toList();
  }
}
