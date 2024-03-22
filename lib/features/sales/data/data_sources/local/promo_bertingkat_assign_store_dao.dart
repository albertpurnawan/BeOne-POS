import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_bertingkat_assign_store.dart';
import 'package:sqflite/sqflite.dart';

class PromoBertingkatAssignStoreDao
    extends BaseDao<PromoBertingkatAssignStoreModel> {
  PromoBertingkatAssignStoreDao(Database db)
      : super(
          db: db,
          tableName: tablePromoBertingkatAssignStore,
          modelFields: PromoBertingkatAssignStoreFields.values,
        );

  @override
  Future<PromoBertingkatAssignStoreModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty
        ? PromoBertingkatAssignStoreModel.fromMap(res[0])
        : null;
  }

  @override
  Future<List<PromoBertingkatAssignStoreModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => PromoBertingkatAssignStoreModel.fromMap(itemData))
        .toList();
  }
}