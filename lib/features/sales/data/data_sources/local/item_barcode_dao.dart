import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/item_barcode.dart';
import 'package:sqflite/sqflite.dart';

class ItemBarcodeDao extends BaseDao<ItemBarcodeModel> {
  ItemBarcodeDao(Database db) : super(db: db, tableName: tableItemBarcodes, modelFields: ItemBarcodesFields.values);

  @override
  Future<ItemBarcodeModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ItemBarcodeModel.fromMap(res[0]) : null;
  }

  Future<ItemBarcodeModel?> readByDocToitmId(
      String toitmId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'toitmId = ?',
      whereArgs: [toitmId],
    );

    return res.isNotEmpty ? ItemBarcodeModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<ItemBarcodeModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => ItemBarcodeModel.fromMap(itemData)).toList();
  }

  Future<ItemBarcodeModel?> readByBarcode(String barcode, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'barcode = ?',
      whereArgs: [barcode],
    );

    return res.isNotEmpty ? ItemBarcodeModel.fromMap(res[0]) : null;
  }
}
