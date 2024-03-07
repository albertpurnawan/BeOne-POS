import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/user_role.dart';
import 'package:sqflite/sqflite.dart';

class UserRoleDao extends BaseDao<UserRoleModel> {
  UserRoleDao(Database db)
      : super(
          db: db,
          tableName: tableUserRole,
          modelFields: UserRoleFields.values,
        );

  @override
  Future<UserRoleModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? UserRoleModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<UserRoleModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => UserRoleModel.fromMap(itemData)).toList();
  }
}
