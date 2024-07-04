import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/means_of_payment.dart';
import 'package:sqflite/sqflite.dart';

class MeansOfPaymentDao extends BaseDao<MeansOfPaymentModel> {
  MeansOfPaymentDao(Database db)
      : super(
          db: db,
          tableName: tableMOP,
          modelFields: MeansOfPaymentFields.values,
        );

  @override
  Future<MeansOfPaymentModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? MeansOfPaymentModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<MeansOfPaymentModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => MeansOfPaymentModel.fromMap(itemData))
        .toList();
  }

  Future<MeansOfPaymentModel?> readByDescription(
      String description, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'description = ?',
      whereArgs: [description],
    );

    return res.isNotEmpty ? MeansOfPaymentModel.fromMap(res[0]) : null;
  }

  Future<List<dynamic>?> readByPaytypeCode(String payTypeCode) async {
    final result = await db.rawQuery('''
      SELECT x0.* FROM tpmt1 AS x0 
      INNER JOIN topmt AS x1 ON x0.topmtId = x1.docid
      WHERE x1.paytypecode = ?
    ''', [payTypeCode]);

    return result;
  }
}
