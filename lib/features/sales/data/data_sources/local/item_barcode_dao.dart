import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/item_barcode.dart';
import 'package:sqflite/sqflite.dart';

class ItemBarcodeDao extends BaseDao<ItemBarcodeModel> {
  ItemBarcodeDao(Database db)
      : super(
            db: db,
            tableName: tableItemBarcodes,
            modelFields: ItemBarcodesFields.values);

  @override
  Future<ItemBarcodeModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ItemBarcodeModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<ItemBarcodeModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => ItemBarcodeModel.fromMap(itemData))
        .toList();
  }
}
