import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/pay_means.dart';
import 'package:sqflite/sqflite.dart';

class PayMeansDao extends BaseDao<PayMeansModel> {
  PayMeansDao(Database db)
      : super(
          db: db,
          tableName: tablePayMeans,
          modelFields: PayMeansFields.values,
        );

  @override
  Future<PayMeansModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PayMeansModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PayMeansModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => PayMeansModel.fromMap(itemData)).toList();
  }
}
