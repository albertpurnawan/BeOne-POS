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
    final result = await db.query(tableName);

    return result
        .map((itemData) => MeansOfPaymentModel.fromMap(itemData))
        .toList();
  }
}
