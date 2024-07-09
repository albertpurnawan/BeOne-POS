import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/credit_card.dart';
import 'package:sqflite/sqflite.dart';

class CreditCardDao extends BaseDao<CreditCardModel> {
  String statusActive = "AND statusactive = 1";
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
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => CreditCardModel.fromMap(itemData)).toList();
  }

  // Future<List<CreditCardModel>> readAllWithSearch(
  //     {String? searchKeyword, Transaction? txn}) async {
  //   // final result = await db.query(tableName,
  //   //     where:
  //   //         "(${CreditCardFields.description} LIKE ? OR ${CreditCardFields.bankIssuer} LIKE ?) $statusActive",
  //   //     whereArgs: ["%$searchKeyword%", "%$searchKeyword%"]);

  //   return result.map((itemData) => CreditCardModel.fromMap(itemData)).toList();
  // }
}
