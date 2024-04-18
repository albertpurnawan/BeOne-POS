import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/money_denomination.dart';
import 'package:sqflite/sqflite.dart';

class MoneyDenominationDao extends BaseDao<MoneyDenominationModel> {
  MoneyDenominationDao(Database db)
      : super(
          db: db,
          tableName: tableMoneyDemonination,
          modelFields: MoneyDenominationFields.values,
        );

  @override
  Future<MoneyDenominationModel?> readByDocId(
      String docId, Transaction? txn) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? MoneyDenominationModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<MoneyDenominationModel>> readAll({Transaction? txn}) async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => MoneyDenominationModel.fromMap(itemData))
        .toList();
  }
}
