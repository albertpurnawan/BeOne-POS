import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:sqflite/sqflite.dart';

class ItemsDao extends BaseDao<ItemModel> {
  ItemsDao(Database db) : super(db: db, tableName: tableItems, modelFields: ItemFields.values);

  Future<ItemModel?> readItemByBarcode(String barcode) async {
    final maps = await db
        .query(tableItems, columns: ItemFields.values, where: '${ItemFields.barcode} = ?', whereArgs: [barcode]);

    if (maps.isNotEmpty) {
      return ItemModel.fromMap(maps.first);
    } else {
      throw "Barcode [$barcode] is not found";
    }
  }

  Future<ItemModel> createItem(ItemModel itemModel) async {
    final id = await db.insert(tableItems, itemModel.toMap());

    return ItemModel.fromEntity(itemModel.copyWith(id: id));
  }

  Future<ItemModel> readItem(int id) async {
    final maps = await db.query(
      tableItems,
      columns: ItemFields.values,
      where: '${ItemFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ItemModel.fromMap(maps.first);
    } else {
      throw Exception("ID $id is not found");
    }
  }

  Future<List<ItemModel>> readItems() async {
    const orderBy = '${ItemFields.id} DESC';
    final result = await db.query(tableItems, orderBy: orderBy);

    return result.map((itemData) => ItemModel.fromMap(itemData)).toList();
  }

  @override
  Future<List<ItemModel>> readAll({String? searchKeyword, Transaction? txn}) async {
    final result = await db.query(
      tableName,
      where:
          "${ItemFields.itemName} LIKE ? OR ${ItemFields.barcode} LIKE ? OR ${ItemFields.itemCode} LIKE ? OR ${ItemFields.shortName} LIKE ?",
      whereArgs: ["%$searchKeyword%", "%$searchKeyword%", "%$searchKeyword%", "%$searchKeyword%"],
      orderBy: "itemname",
      limit: 300,
    );
    // log(result[0].toString());
    return result.map((itemData) => ItemModel.fromMap(itemData)).toList();
  }

  Future<List<ItemModel>> readAllByPricelist(
      {String? searchKeyword, Transaction? txn, required String pricelistId}) async {
    final result = await db.query(
      tableName,
      where:
          "(${ItemFields.itemName} LIKE ? OR ${ItemFields.barcode} LIKE ? OR ${ItemFields.itemCode} LIKE ? OR ${ItemFields.shortName} LIKE ?) AND ${ItemFields.toplnId} = ?",
      whereArgs: ["%$searchKeyword%", "%$searchKeyword%", "%$searchKeyword%", "%$searchKeyword%", pricelistId],
      orderBy: "itemname",
      limit: 300,
    );
    // log(result[0].toString());
    return result.map((itemData) => ItemModel.fromMap(itemData)).toList();
  }

  @override
  Future<ItemModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ItemModel.fromMap(res[0]) : null;
  }

  Future<ItemModel?> readByToitmId(String toitmId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'toitmId = ?',
      whereArgs: [toitmId],
    );

    return res.isNotEmpty ? ItemModel.fromMap(res[0]) : null;
  }

  Future<ItemModel?> readItemWithAndCondition(Map<String, dynamic> conditions, Transaction? txn) async {
    try {
      DatabaseExecutor dbExecutor = txn ?? db;
      final res = await dbExecutor.query(
        tableName,
        columns: modelFields,
        where: conditions.keys.isEmpty ? null : conditions.keys.map((e) => "$e = ?").join(" AND "),
        whereArgs: conditions.values.isEmpty ? null : conditions.values.toList(),
      );

      return res.isNotEmpty ? ItemModel.fromMap(res[0]) : null;
    } catch (e) {
      rethrow;
    }
  }
}
