import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:sqflite/sqflite.dart';

class CashierBalanceTransactionDao
    extends BaseDao<CashierBalanceTransactionModel> {
  CashierBalanceTransactionDao(Database db)
      : super(
          db: db,
          tableName: tableCashierBalanceTransaction,
          modelFields: CashierBalanceTransactionFields.values,
        );

  @override
  Future<CashierBalanceTransactionModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? CashierBalanceTransactionModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<CashierBalanceTransactionModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => CashierBalanceTransactionModel.fromMap(itemData))
        .toList();
  }
}
