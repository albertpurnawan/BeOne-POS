import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_group_item_customer_group.dart';
import 'package:sqflite/sqflite.dart';

class PromoDiskonGroupItemCustomerGroupDao
    extends BaseDao<PromoDiskonGroupItemCustomerGroupModel> {
  PromoDiskonGroupItemCustomerGroupDao(Database db)
      : super(
          db: db,
          tableName: tablePromoDiskonGroupItemCustomerGroup,
          modelFields: PromoDiskonGroupItemCustomerGroupFields.values,
        );

  @override
  Future<PromoDiskonGroupItemCustomerGroupModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoDiskonGroupItemCustomerGroupModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoDiskonGroupItemCustomerGroupModel>> readAll(
      {Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result
          .map((itemData) =>
              PromoDiskonGroupItemCustomerGroupModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(tableName);

      return result
          .map((itemData) =>
              PromoDiskonGroupItemCustomerGroupModel.fromMap(itemData))
          .toList();
    }
  }
}
