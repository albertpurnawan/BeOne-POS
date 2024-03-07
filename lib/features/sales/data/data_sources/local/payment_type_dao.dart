import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/payment_type.dart';
import 'package:sqflite/sqflite.dart';

class PaymentTypeDao extends BaseDao<PaymentTypeModel> {
  PaymentTypeDao(Database db)
      : super(
          db: db,
          tableName: tablePaymentType,
          modelFields: PaymentTypeFields.values,
        );

  @override
  Future<PaymentTypeModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PaymentTypeModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PaymentTypeModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PaymentTypeModel.fromMap(itemData))
        .toList();
  }
}
