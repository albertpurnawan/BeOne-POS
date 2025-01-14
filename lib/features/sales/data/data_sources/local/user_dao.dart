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
  Future<UserModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? UserModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<UserModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => UserModel.fromMap(itemData)).toList();
  }

  Future<UserModel?> readByUsername(String username, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'username = ?',
      whereArgs: [username],
    );

    return res.isNotEmpty ? UserModel.fromMap(res[0]) : null;
  }

  Future<UserModel?> readbyEmail(String email, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'email = ?',
      whereArgs: [email],
    );

    return res.isNotEmpty ? UserModel.fromMap(res[0]) : null;
  }
}
