import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/currency.dart';
import 'package:pos_fe/features/sales/data/models/preferred_vendor.dart';
import 'package:sqflite/sqflite.dart';

class PreferredVendorDao extends BaseDao<PreferredVendorModel> {
  PreferredVendorDao(Database db)
      : super(
            db: db,
            tableName: tableCurrencies,
            modelFields: CurrencyFields.values);

  @override
  Future<PreferredVendorModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PreferredVendorModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PreferredVendorModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PreferredVendorModel.fromMap(itemData))
        .toList();
  }
}
