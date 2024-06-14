import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_package_customer_group.dart';
import 'package:sqflite/sqflite.dart';

class PromoPackageCustomerGroupDao
    extends BaseDao<PromoPackageCustomerGroupModel> {
  PromoPackageCustomerGroupDao(Database db)
      : super(
          db: db,
          tableName: tablePromoPackageCustomerGroup,
          modelFields: PromoPackageCustomerGroupFields.values,
        );

  @override
  Future<PromoPackageCustomerGroupModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoPackageCustomerGroupModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoPackageCustomerGroupModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => PromoPackageCustomerGroupModel.fromMap(itemData))
        .toList();
  }
}
