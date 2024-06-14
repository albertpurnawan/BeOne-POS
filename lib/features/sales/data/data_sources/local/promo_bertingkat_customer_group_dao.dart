import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_bertingkat_customer_group.dart';
import 'package:sqflite/sqflite.dart';

class PromoBertingkatCustomerGroupDao
    extends BaseDao<PromoBertingkatCustomerGroupModel> {
  PromoBertingkatCustomerGroupDao(Database db)
      : super(
          db: db,
          tableName: tablePromoBertingkatCustomerGroup,
          modelFields: PromoBertingkatCustomerGroupFields.values,
        );

  @override
  Future<PromoBertingkatCustomerGroupModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoBertingkatCustomerGroupModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoBertingkatCustomerGroupModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => PromoBertingkatCustomerGroupModel.fromMap(itemData))
        .toList();
  }
}
