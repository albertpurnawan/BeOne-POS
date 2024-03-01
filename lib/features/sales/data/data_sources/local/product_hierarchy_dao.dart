import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/currency.dart';
import 'package:pos_fe/features/sales/data/models/product_hierarchy.dart';
import 'package:sqflite/sqflite.dart';

class ProductHierarchyDao extends BaseDao<ProductHierarchyModel> {
  ProductHierarchyDao(Database db)
      : super(
            db: db,
            tableName: tableCurrencies,
            modelFields: CurrencyFields.values);

  @override
  Future<ProductHierarchyModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ProductHierarchyModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<ProductHierarchyModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => ProductHierarchyModel.fromMap(itemData))
        .toList();
  }
}
