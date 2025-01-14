import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/authentication_store.dart';
import 'package:sqflite/sqflite.dart';

class AuthStoreDao extends BaseDao<AuthStoreModel> {
  AuthStoreDao(Database db) : super(db: db, tableName: tableAuthStore, modelFields: AuthStoreFields.values);

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
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => AuthStoreModel.fromMap(itemData)).toList();
  }

  Future<AuthStoreModel?> readByTousrId(String tousrdocid, String category, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'tousrdocid = ? AND statusactive = 1 AND $category = 1',
      whereArgs: [tousrdocid],
    );

    return res.isNotEmpty ? AuthStoreModel.fromMap(res.first) : null;
  }

  Future<List<dynamic>?> readEmailByTousrId() async {
    final res = await db.rawQuery('''
    SELECT x0.*, x1.username, x1.email FROM tastr AS x0 
      INNER JOIN tousr AS x1 
      ON x0.tousrdocid = x1.docid
      WHERE x0.statusactive = 1 AND x0.dflt = 1
    ''');

    return res;
  }
}
