import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/bill_of_material.dart';
import 'package:sqflite/sqflite.dart';

class BillOfMaterialDao extends BaseDao<BillOfMaterialModel> {
  BillOfMaterialDao(Database db)
      : super(
          db: db,
          tableName: tableBillOfMaterial,
          modelFields: BillOfMaterialFields.values,
        );

  @override
  Future<BillOfMaterialModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? BillOfMaterialModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<BillOfMaterialModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => BillOfMaterialModel.fromMap(itemData))
        .toList();
  }
}
