import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/authentication_store.dart';
import 'package:sqflite/sqflite.dart';

class AuthStoreDao extends BaseDao<AuthStoreModel> {
  AuthStoreDao(Database db)
      : super(
            db: db,
            tableName: tableAuthStore,
            modelFields: AuthStoreFields.values);

  @override
  Future<AuthStoreModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? AuthStoreModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<AuthStoreModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result.map((itemData) => AuthStoreModel.fromMap(itemData)).toList();
  }

  Future<AuthStoreModel?> readByTousrId(
      String tousrdocid, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'tousrdocid = ?',
      whereArgs: [tousrdocid],
    );

    return res.isNotEmpty ? AuthStoreModel.fromMap(res[0]) : null;
  }
}
