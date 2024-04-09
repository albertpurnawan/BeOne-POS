import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:sqflite/sqflite.dart';

class ItemsDao extends BaseDao<ItemModel> {
  ItemsDao(Database db)
      : super(db: db, tableName: tableItems, modelFields: ItemFields.values);

  Future<ItemModel?> readItemByBarcode(String barcode) async {
    final maps = await db.query(tableItems,
        columns: ItemFields.values,
        where: '${ItemFields.barcode} = ?',
        whereArgs: [barcode]);

    if (maps.isNotEmpty) {
      print(maps.first);
      return ItemModel.fromMap(maps.first);
    } else {
      throw Exception("ID $barcode is not found");
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
  Future<List<ItemModel>> readAll({Transaction? txn}) async {
    // TODO: implement readAll
    throw UnimplementedError();
  }

  @override
  Future<ItemModel?> readByDocId(String docId, Transaction? txn) async {
    // TODO: implement readByDocId
    throw UnimplementedError();
  }
}
