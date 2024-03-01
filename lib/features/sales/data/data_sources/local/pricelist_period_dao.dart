import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/currency.dart';
import 'package:pos_fe/features/sales/data/models/pricelist_period.dart';
import 'package:sqflite/sqflite.dart';

class PricelistPeriodDao extends BaseDao<PricelistPeriodModel> {
  PricelistPeriodDao(Database db)
      : super(
            db: db,
            tableName: tableCurrencies,
            modelFields: CurrencyFields.values);

  @override
  Future<PricelistPeriodModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PricelistPeriodModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PricelistPeriodModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PricelistPeriodModel.fromMap(itemData))
        .toList();
  }
}
