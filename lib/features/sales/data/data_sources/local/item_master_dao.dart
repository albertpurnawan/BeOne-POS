import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/currency.dart';
import 'package:pos_fe/features/sales/data/models/item_master.dart';
import 'package:sqflite/sqflite.dart';

class ItemMasterDao extends BaseDao<ItemMasterModel> {
  ItemMasterDao(Database db)
      : super(
            db: db,
            tableName: tableCurrencies,
            modelFields: CurrencyFields.values);

  @override
  Future<ItemMasterModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ItemMasterModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<ItemMasterModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => ItemMasterModel.fromMap(itemData)).toList();
  }
}
