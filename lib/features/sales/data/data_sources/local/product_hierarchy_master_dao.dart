import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/product_hierarchy_master.dart';
import 'package:sqflite/sqflite.dart';

class ProductHierarchyMasterDao extends BaseDao<ProductHierarchyMasterModel> {
  ProductHierarchyMasterDao(Database db)
      : super(
            db: db,
            tableName: tableProductHierarchyMasters,
            modelFields: ProductHierarchyMasterFields.values);

  @override
  Future<ProductHierarchyMasterModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ProductHierarchyMasterModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<ProductHierarchyMasterModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => ProductHierarchyMasterModel.fromMap(itemData))
        .toList();
  }
}
