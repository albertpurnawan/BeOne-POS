import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_gwp_customer_group.dart';
import 'package:sqflite/sqflite.dart';

class PromoGWPCustomerGroupDao extends BaseDao<PromoGWPCustomerGroupModel> {
  PromoGWPCustomerGroupDao(Database db)
      : super(
          db: db,
          tableName: tablePromoGWPCustomerGroup,
          modelFields: PromoGWPCustomerGroupFields.values,
        );

  @override
  Future<PromoGWPCustomerGroupModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoGWPCustomerGroupModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoGWPCustomerGroupModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => PromoGWPCustomerGroupModel.fromMap(itemData))
        .toList();
  }
}
