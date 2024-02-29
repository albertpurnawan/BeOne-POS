import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/item_category.dart';
import 'package:sqflite/sqflite.dart';

class ItemCategoryDao extends BaseDao<ItemCategoryModel> {
  ItemCategoryDao(Database db)
      : super(
            db: db,
            tableName: tableItemCategories,
            modelFields: ItemCategoryFields.values);

  @override
  Future<List<ItemCategoryModel>> readAll() {
    // TODO: implement readAll
    throw UnimplementedError();
  }

  @override
  Future<ItemCategoryModel?> readByDocId(String docId) {
    // TODO: implement readByDocId
    throw UnimplementedError();
  }
  // final Database db;
  // final String tableName = tableItemCategories;

  // ItemCategoryDao(this.db);

  // Future<ItemCategoryModel> create(ItemCategoryModel currencyModel) async {
  //   final res = await db.insert(tableName, currencyModel.toMap());
  //   return currencyModel;
  // }

  // Future<void> bulkCreate(List<ItemCategoryModel> data) async {
  //   await DaoHelper.bulkCreate(db, tableName, data);
  // }

  // Future<ItemCategoryModel> readByDocId(String docId) async {
  //   final maps = await db.query(
  //     tableName,
  //     columns: CurrencyFields.values,
  //     where: '${CurrencyFields.docId} = ?',
  //     whereArgs: [docId],
  //   );

  //   if (maps.isNotEmpty) {
  //     return ItemCategoryModel.fromMap(maps.first);
  //   } else {
  //     throw Exception("ID $docId is not found");
  //   }
  // }

  // Future<List<ItemCategoryModel>> readAll() async {
  //   final result = await db.query(tableName);

  //   return result
  //       .map((itemData) => ItemCategoryModel.fromMap(itemData))
  //       .toList();
  // }
}
