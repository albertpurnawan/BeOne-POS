import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_item_customer_group.dart';
import 'package:sqflite/sqflite.dart';

class PromoDiskonItemCustomerGroupDao
    extends BaseDao<PromoDiskonItemCustomerGroupModel> {
  PromoDiskonItemCustomerGroupDao(Database db)
      : super(
          db: db,
          tableName: tablePromoDiskonItemCustomerGroup,
          modelFields: PromoDiskonItemCustomerGroupFields.values,
        );

  @override
  Future<PromoDiskonItemCustomerGroupModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoDiskonItemCustomerGroupModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoDiskonItemCustomerGroupModel>> readAll(
      {Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result
          .map(
              (itemData) => PromoDiskonItemCustomerGroupModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(tableName);

      return result
          .map(
              (itemData) => PromoDiskonItemCustomerGroupModel.fromMap(itemData))
          .toList();
    }
  }
}
