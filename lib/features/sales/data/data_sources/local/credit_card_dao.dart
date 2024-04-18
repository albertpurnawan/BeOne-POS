import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/credit_card.dart';
import 'package:sqflite/sqflite.dart';

class CreditCardDao extends BaseDao<CreditCardModel> {
  CreditCardDao(Database db)
      : super(
          db: db,
          tableName: tableCC,
          modelFields: CreditCardFields.values,
        );

  @override
  Future<CreditCardModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? CreditCardModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<CreditCardModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result.map((itemData) => CreditCardModel.fromMap(itemData)).toList();
  }
}
