import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDao extends BaseDao<UserModel> {
  UserDao(Database db)
      : super(
          db: db,
          tableName: tableUser,
          modelFields: UserFields.values,
        );

  @override
  Future<UserModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? UserModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<UserModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => UserModel.fromMap(itemData)).toList();
  }
}