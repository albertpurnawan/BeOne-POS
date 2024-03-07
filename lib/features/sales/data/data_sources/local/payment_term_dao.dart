import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/payment_term.dart';
import 'package:sqflite/sqflite.dart';

class PaymentTermDao extends BaseDao<PaymentTermModel> {
  PaymentTermDao(Database db)
      : super(
          db: db,
          tableName: tablePaymentTerm,
          modelFields: PaymentTermFields.values,
        );

  @override
  Future<PaymentTermModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PaymentTermModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PaymentTermModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PaymentTermModel.fromMap(itemData))
        .toList();
  }
}
