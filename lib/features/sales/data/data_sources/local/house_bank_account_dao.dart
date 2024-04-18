import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/house_bank_account.dart';
import 'package:sqflite/sqflite.dart';

class HouseBankAccountDao extends BaseDao<HouseBankAccountModel> {
  HouseBankAccountDao(Database db)
      : super(
          db: db,
          tableName: tableHouseBankAccount,
          modelFields: HouseBankAccountFields.values,
        );

  @override
  Future<HouseBankAccountModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? HouseBankAccountModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<HouseBankAccountModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => HouseBankAccountModel.fromMap(itemData))
        .toList();
  }
}
