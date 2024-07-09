import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/bank_issuer.dart';
import 'package:sqflite/sqflite.dart';

class BankIssuerDao extends BaseDao<BankIssuerModel> {
  BankIssuerDao(Database db)
      : super(
            db: db,
            tableName: tableBankIssuer,
            modelFields: BankIssuerFields.values);

  @override
  Future<BankIssuerModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? BankIssuerModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<BankIssuerModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => BankIssuerModel.fromMap(itemData)).toList();
  }
}
