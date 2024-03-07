import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/invoice_payment_other_voucher.dart';
import 'package:sqflite/sqflite.dart';

class IPOVDao extends BaseDao<IPOVModel> {
  IPOVDao(Database db)
      : super(
          db: db,
          tableName: tableIPOV,
          modelFields: IPOVFields.values,
        );

  @override
  Future<IPOVModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? IPOVModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<IPOVModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => IPOVModel.fromMap(itemData)).toList();
  }
}
