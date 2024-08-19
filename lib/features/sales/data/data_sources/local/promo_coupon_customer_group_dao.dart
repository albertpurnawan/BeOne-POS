import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_coupon_customer_group.dart';
import 'package:sqflite/sqflite.dart';

class PromoCouponCustomerGroupDao extends BaseDao<PromoCouponCustomerGroupModel> {
  PromoCouponCustomerGroupDao(Database db)
      : super(
          db: db,
          tableName: tablePromoCouponCustomerGroup,
          modelFields: PromoCouponCustomerGroupFields.values,
        );

  @override
  Future<PromoCouponCustomerGroupModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoCouponCustomerGroupModel.fromMap(res[0]) : null;
  }

  Future<List<PromoCouponCustomerGroupModel>> readByToprnId(String toprnId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'toprnId = ?',
      whereArgs: [toprnId],
    );

    return res.map((itemData) => PromoCouponCustomerGroupModel.fromMap(itemData)).toList();
  }

  @override
  Future<List<PromoCouponCustomerGroupModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => PromoCouponCustomerGroupModel.fromMap(itemData)).toList();
  }
}
