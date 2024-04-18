import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_bertingkat.dart';
import 'package:sqflite/sqflite.dart';

class PromoBertingkatDao extends BaseDao<PromoBertingkatModel> {
  PromoBertingkatDao(Database db)
      : super(
          db: db,
          tableName: tablePromoBertingkat,
          modelFields: PromoBertingkatFields.values,
        );

  @override
  Future<PromoBertingkatModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoBertingkatModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoBertingkatModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoBertingkatModel.fromMap(itemData))
        .toList();
  }
}
