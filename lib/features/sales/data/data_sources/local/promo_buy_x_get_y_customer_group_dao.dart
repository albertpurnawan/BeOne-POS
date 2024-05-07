import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_customer_group.dart';
import 'package:sqflite/sqflite.dart';

class PromoBuyXGetYCustomerGroupDao
    extends BaseDao<PromoBuyXGetYCustomerGroupModel> {
  PromoBuyXGetYCustomerGroupDao(Database db)
      : super(
          db: db,
          tableName: tablePromoBuyXGetYCustomerGroup,
          modelFields: PromoBuyXGetYCustomerGroupFields.values,
        );

  @override
  Future<PromoBuyXGetYCustomerGroupModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoBuyXGetYCustomerGroupModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoBuyXGetYCustomerGroupModel>> readAll(
      {Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result
          .map((itemData) => PromoBuyXGetYCustomerGroupModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(tableName);

      return result
          .map((itemData) => PromoBuyXGetYCustomerGroupModel.fromMap(itemData))
          .toList();
    }
  }

  Future<List<PromoBuyXGetYCustomerGroupModel>> readByToprbid(
      String toprbId, Transaction? txn) async {
    if (txn != null) {
      final result = await txn.query(
        tableName,
        columns: modelFields,
        where: 'toprbId = ?',
        whereArgs: [toprbId],
      );
      return result
          .map((itemData) => PromoBuyXGetYCustomerGroupModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(
        tableName,
        columns: modelFields,
        where: 'toprbId = ?',
        whereArgs: [toprbId],
      );
      return result
          .map((itemData) => PromoBuyXGetYCustomerGroupModel.fromMap(itemData))
          .toList();
    }
  }
}
