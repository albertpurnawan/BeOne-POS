import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/payment_type_master.dart';
import 'package:sqflite/sqflite.dart';

class PaymentTypeMasterDao extends BaseDao<PaymentTypeMasterModel> {
  PaymentTypeMasterDao(Database db)
      : super(
          db: db,
          tableName: tablePaymentTypeMaster,
          modelFields: PaymentTypeMasterFields.values,
        );

  @override
  Future<PaymentTypeMasterModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PaymentTypeMasterModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PaymentTypeMasterModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result
        .map((itemData) => PaymentTypeMasterModel.fromMap(itemData))
        .toList();
  }
}
