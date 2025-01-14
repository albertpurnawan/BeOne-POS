import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_valid_days.dart';
import 'package:sqflite/sqflite.dart';

class PromoBuyXGetYValidDaysDao extends BaseDao<PromoBuyXGetYValidDaysModel> {
  PromoBuyXGetYValidDaysDao(Database db)
      : super(
          db: db,
          tableName: tablePromoBuyXGetYValidDays,
          modelFields: PromoBuyXGetYValidDaysFields.values,
        );

  @override
  Future<PromoBuyXGetYValidDaysModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoBuyXGetYValidDaysModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoBuyXGetYValidDaysModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => PromoBuyXGetYValidDaysModel.fromMap(itemData))
        .toList();
  }
}
