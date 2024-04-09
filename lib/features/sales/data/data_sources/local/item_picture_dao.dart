import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/item_picture.dart';
import 'package:sqflite/sqflite.dart';

class ItemPictureDao extends BaseDao<ItemPictureModel> {
  ItemPictureDao(Database db)
      : super(
          db: db,
          tableName: tableItemPicture,
          modelFields: ItemPictureFields.values,
        );

  @override
  Future<ItemPictureModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ItemPictureModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<ItemPictureModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => ItemPictureModel.fromMap(itemData))
        .toList();
  }
}
