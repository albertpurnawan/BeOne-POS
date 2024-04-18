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
  Future<CashierBalanceTransactionModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
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
  Future<List<CashierBalanceTransactionModel>> readAll(
      {Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => CashierBalanceTransactionModel.fromMap(itemData))
        .toList();
  }

  Future<double> insertValue(double value) async {
    final result = await db.insert('tcsr1', {'value': value});

    return result.toDouble();
  }

  Future<CashierBalanceTransactionModel?> readLastValue() async {
    final result = await db.query(
      tableName,
      orderBy: 'createdat DESC',
      limit: 1,
    );

    return result.isNotEmpty
        ? CashierBalanceTransactionModel.fromMap(result[0])
        : null;
  }

  Future<List<CashierBalanceTransactionModel>?> readByDate(
      DateTime date) async {
    final startOfDay =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final endOfDay =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} 23:59:59';

    final result = await db.query(
      tableName,
      where: 'createdat BETWEEN ? AND ?',
      whereArgs: [startOfDay, endOfDay],
    );

    final transactions = result
        .map((map) => CashierBalanceTransactionModel.fromMap(map))
        .toList();

    return transactions;
  }
}
