import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/dual_screen/data/models/dual_screen.dart';
import 'package:sqflite/sqflite.dart';

class DualScreenDao extends BaseDao<DualScreenModel> {
  DualScreenDao(Database db)
      : super(
          db: db,
          tableName: 'tobnr',
          modelFields: DualScreenFields.values,
        );

  Future<void> createTable() async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        ${DualScreenFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DualScreenFields.description} TEXT NOT NULL,
        ${DualScreenFields.type} INTEGER NOT NULL,
        `${DualScreenFields.order}` INTEGER NOT NULL,
        ${DualScreenFields.path} TEXT NOT NULL,
        ${DualScreenFields.duration} INTEGER NOT NULL,
        ${DualScreenFields.createdAt} INTEGER,
        ${DualScreenFields.updatedAt} INTEGER
      )
    ''');
  }

  Future<int> delete(int id) async {
    return await db.delete(
      tableName,
      where: '${DualScreenFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<DualScreenModel?> findById(int id) async {
    final maps = await db.query(
      tableName,
      where: '${DualScreenFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return DualScreenModel.fromMap(maps.first);
  }

  Future<List<DualScreenModel>> findAll() async {
    final maps = await db.query(tableName);
    return maps.map((map) => DualScreenModel.fromMap(map)).toList();
  }

  Future<List<DualScreenModel>> findByType(int type) async {
    final maps = await db.query(
      tableName,
      where: '${DualScreenFields.type} = ?',
      whereArgs: [type],
      orderBy: '`${DualScreenFields.order}` ASC',
    );
    return maps.map((map) => DualScreenModel.fromMap(map)).toList();
  }

  Future<int> updateOrder(int id, int newOrder) async {
    return await db.update(
      tableName,
      {'${DualScreenFields.order}': newOrder},
      where: '${DualScreenFields.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<DualScreenModel>> readAll({Transaction? txn}) async {
    final query = txn ?? db;
    final maps = await query.query(
      tableName,
      orderBy: '`${DualScreenFields.order}` ASC, ${DualScreenFields.type} ASC',
    );
    return maps.map((map) => DualScreenModel.fromMap(map)).toList();
  }

  @override
  Future<DualScreenModel?> readByDocId(String docId, Transaction? txn) async {
    final query = txn ?? db;
    final maps = await query.query(
      tableName,
      where: '${DualScreenFields.id} = ?',
      whereArgs: [int.parse(docId)],
    );

    if (maps.isEmpty) return null;
    return DualScreenModel.fromMap(maps.first);
  }
}
