import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/assign_price_member_per_store.dart';
import 'package:sqflite/sqflite.dart';

class AssignPriceMemberPerStoreDao
    extends BaseDao<AssignPriceMemberPerStoreModel> {
  AssignPriceMemberPerStoreDao(Database db)
      : super(
          db: db,
          tableName: tableAPMPS,
          modelFields: AssignPriceMemberPerStoreFields.values,
        );

  @override
  Future<AssignPriceMemberPerStoreModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? AssignPriceMemberPerStoreModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<AssignPriceMemberPerStoreModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => AssignPriceMemberPerStoreModel.fromMap(itemData))
        .toList();
  }
}
