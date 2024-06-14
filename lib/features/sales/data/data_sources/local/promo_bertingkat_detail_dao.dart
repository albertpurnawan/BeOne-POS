import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_bertingkat_detail.dart';
import 'package:sqflite/sqflite.dart';

class PromoBertingkatDetailDao extends BaseDao<PromoBertingkatDetailModel> {
  PromoBertingkatDetailDao(Database db)
      : super(
          db: db,
          tableName: tablePromoBertingkatDetail,
          modelFields: PromoBertingkatDetailFields.values,
        );

  @override
  Future<PromoBertingkatDetailModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoBertingkatDetailModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoBertingkatDetailModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => PromoBertingkatDetailModel.fromMap(itemData))
        .toList();
  }
}
