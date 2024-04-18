import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/cash_register.dart';
import 'package:sqflite/sqflite.dart';

class CashRegisterDao extends BaseDao<CashRegisterModel> {
  CashRegisterDao(Database db)
      : super(
          db: db,
          tableName: tableCashRegister,
          modelFields: CashRegisterFields.values,
        );

  @override
  Future<CashRegisterModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? CashRegisterModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<CashRegisterModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => CashRegisterModel.fromMap(itemData))
        .toList();
  }
}
