import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/authorization.dart';
import 'package:sqflite/sqflite.dart';

class AuthorizationDao extends BaseDao<AuthorizationModel> {
  AuthorizationDao(Database db)
      : super(
          db: db,
          tableName: tableAuthorization,
          modelFields: AuthorizationFields.values,
        );

  @override
  Future<AuthorizationModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? AuthorizationModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<AuthorizationModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => AuthorizationModel.fromMap(itemData))
        .toList();
  }
}
