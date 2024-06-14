import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/item_remarks.dart';
import 'package:sqflite/sqflite.dart';

class ItemRemarkDao extends BaseDao<ItemRemarksModel> {
  ItemRemarkDao(Database db)
      : super(
          db: db,
          tableName: tableItemRemarks,
          modelFields: ItemRemarksFields.values,
        );

  @override
  Future<ItemRemarksModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? ItemRemarksModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<ItemRemarksModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => ItemRemarksModel.fromMap(itemData))
        .toList();
  }
}
