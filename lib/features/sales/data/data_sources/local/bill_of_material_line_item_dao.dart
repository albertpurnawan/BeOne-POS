import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/bill_of_material_line_item.dart';
import 'package:sqflite/sqflite.dart';

class BillOfMaterialLineItemDao extends BaseDao<BillOfMaterialLineItemModel> {
  BillOfMaterialLineItemDao(Database db)
      : super(
          db: db,
          tableName: tableBOMLineItem,
          modelFields: BillOfMaterialLineItemFields.values,
        );

  @override
  Future<BillOfMaterialLineItemModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? BillOfMaterialLineItemModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<BillOfMaterialLineItemModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => BillOfMaterialLineItemModel.fromMap(itemData))
        .toList();
  }
}
