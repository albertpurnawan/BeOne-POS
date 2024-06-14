import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_credit_card_assign_store.dart';
import 'package:sqflite/sqflite.dart';

class PromoCreditCardAssignStoreDao
    extends BaseDao<PromoCreditCardAssignStoreModel> {
  PromoCreditCardAssignStoreDao(Database db)
      : super(
          db: db,
          tableName: tablePromoCreditCardAssignStore,
          modelFields: PromoCreditCardAssignStoreFields.values,
        );

  @override
  Future<PromoCreditCardAssignStoreModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoCreditCardAssignStoreModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoCreditCardAssignStoreModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => PromoCreditCardAssignStoreModel.fromMap(itemData))
        .toList();
  }
}
