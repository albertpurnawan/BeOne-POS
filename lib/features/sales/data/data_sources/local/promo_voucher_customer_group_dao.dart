import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_voucher_customer_group.dart';
import 'package:sqflite/sqflite.dart';

class PromoVoucherCustomerGroupDao
    extends BaseDao<PromoVoucherCustomerGroupModel> {
  PromoVoucherCustomerGroupDao(Database db)
      : super(
          db: db,
          tableName: tablePromoVoucherCustomerGroup,
          modelFields: PromoVoucherCustomerGroupFields.values,
        );

  @override
  Future<PromoVoucherCustomerGroupModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoVoucherCustomerGroupModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoVoucherCustomerGroupModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoVoucherCustomerGroupModel.fromMap(itemData))
        .toList();
  }
}
