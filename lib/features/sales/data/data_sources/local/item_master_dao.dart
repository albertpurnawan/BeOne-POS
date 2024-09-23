import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/item_master.dart';
import 'package:sqflite/sqflite.dart';

class ItemMasterDao extends BaseDao<ItemMasterModel> {
  ItemMasterDao(Database db) : super(db: db, tableName: tableItemMasters, modelFields: ItemMasterFields.values);

  @override
  Future<ItemMasterModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ItemMasterModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<ItemMasterModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => ItemMasterModel.fromMap(itemData)).toList();
  }

  Future<List<ItemMasterModel>> readAllByTocatId({required String tocatId, Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName, where: "tocatId = ?", whereArgs: [tocatId]);

    return result.map((itemData) => ItemMasterModel.fromMap(itemData)).toList();
  }

  // Future<ItemMasterModel> getDownPayment({Transaction? txn}) async {
  //   DatabaseExecutor dbExecutor = txn ?? db;
  //   final result = await dbExecutor.query(tableName, where: "itemcode = ?", whereArgs: ["99"]);

  //   return ItemMasterModel.fromMap(result[0]);
  // }

  Future<List<dynamic>?> readByKeyword(String keyword) async {
    try {
      if (keyword.contains("1") && keyword.contains("=")) {
        throw "Invalid search keyword";
      }

      final List<Map<String, Object?>> result;

      if (!keyword.contains("%")) {
        result = await db.rawQuery('''
    SELECT x0.itemname, x0.itemcode, x1.barcode, x2.price, x4.description FROM toitm AS x0 
      INNER JOIN tbitm AS x1 ON x1.toitmId = x0.docid 
      INNER JOIN tpln2 AS x2 ON x2.toitmId = x0.docid
      INNER JOIN tpln1 AS x3 On x2.tpln1Id = x3.docid
      INNER JOIN topln AS x4 ON x3.toplnId = x4.docid
      WHERE x0.itemcode LIKE ? OR x1.barcode LIKE ? OR x0.itemname LIKE ?
      ORDER BY itemname
      LIMIT 300
    ''', ["%$keyword%", "%$keyword%", "%$keyword%"]);
      } else {
        final String itemNameQuery = keyword.split('%').map((e) => "itemname LIKE '%$e%'").join(" AND ");
        final String barcodeQuery = keyword.split('%').map((e) => "barcode LIKE '%$e%'").join(" AND ");
        final String itemCodeQuery = keyword.split('%').map((e) => "itemcode LIKE '%$e%'").join(" AND ");
        final String shortNameQuery = keyword.split('%').map((e) => "shortname LIKE '%$e%'").join(" AND ");

        result = await db.rawQuery('''
    SELECT x0.itemname, x0.itemcode, x1.barcode, x2.price, x4.description FROM toitm AS x0 
      INNER JOIN tbitm AS x1 ON x1.toitmId = x0.docid 
      INNER JOIN tpln2 AS x2 ON x2.toitmId = x0.docid
      INNER JOIN tpln1 AS x3 On x2.tpln1Id = x3.docid
      INNER JOIN topln AS x4 ON x3.toplnId = x4.docid
      WHERE ($itemNameQuery)
      OR ($barcodeQuery)
      OR ($itemCodeQuery)
      OR ($shortNameQuery)
      ORDER BY itemname
      LIMIT 300
    ''');
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
