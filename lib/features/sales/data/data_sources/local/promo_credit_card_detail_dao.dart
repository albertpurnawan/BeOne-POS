import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_credit_card_detail.dart';
import 'package:sqflite/sqflite.dart';

class PromoCreditCardDetailDao extends BaseDao<PromoCreditCardDetailModel> {
  PromoCreditCardDetailDao(Database db)
      : super(
          db: db,
          tableName: tablePromoCreditCardDetail,
          modelFields: PromoCreditCardDetailFields.values,
        );

  @override
  Future<PromoCreditCardDetailModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoCreditCardDetailModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoCreditCardDetailModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => PromoCreditCardDetailModel.fromMap(itemData))
        .toList();
  }
}
