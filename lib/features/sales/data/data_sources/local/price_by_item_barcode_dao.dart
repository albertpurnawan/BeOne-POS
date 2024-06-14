import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/price_by_item_barcode.dart';
import 'package:sqflite/sqflite.dart';

class PriceByItemBarcodeDao extends BaseDao<PriceByItemBarcodeModel> {
  PriceByItemBarcodeDao(Database db)
      : super(
            db: db,
            tableName: tablePricesByItemBarcode,
            modelFields: PriceByItemBarcodeFields.values);

  @override
  Future<PriceByItemBarcodeModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PriceByItemBarcodeModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PriceByItemBarcodeModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => PriceByItemBarcodeModel.fromMap(itemData))
        .toList();
  }
}
