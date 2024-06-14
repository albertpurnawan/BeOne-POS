import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/uom.dart';
import 'package:sqflite/sqflite.dart';

class UomDao extends BaseDao<UomModel> {
  UomDao(Database db)
      : super(db: db, tableName: tableUom, modelFields: UomFields.values);

  @override
  Future<UomModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? UomModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<UomModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => UomModel.fromMap(itemData)).toList();
  }
}
