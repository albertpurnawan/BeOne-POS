// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pos_fe/core/resources/base_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDao<T extends BaseModel> {
  final Database db;
  final String tableName;
  final List<String> modelFields;

  BaseDao({
    required this.db,
    required this.tableName,
    required this.modelFields,
  });

  Future<void> bulkCreate(List<T> data) async {
    await db.transaction((txn) async {
      try {
        final batch = txn.batch();

        for (final e in data) {
          batch.insert(tableName, e.toMap());
        }

        final res = await batch.commit(noResult: true);
        print(res.toString());
      } catch (e) {
        print(e);
        rethrow;
      }
    });
  }

  Future<void> create(T data) async {
    final res = await db.insert(tableName, data.toMap());
    print(res.toString());
  }

  Future<T?> readByDocId(String docId);

  Future<List<T>> readAll();

  // Future<T?> readByDocId(
  //     String docId, T Function(Map<String, dynamic> data) fromMap) async {
  //   final res = await db.query(
  //     tableName,
  //     columns: modelFields,
  //     where: 'docid = ?',
  //     whereArgs: [docId],
  //   );

  //   return res.isNotEmpty ? fromMap(res[0]) : null;
  // }

  // Future<List<T>> readAll(T Function(Map<String, dynamic> data) fromMap) async {
  //   final result = await db.query(tableName);

  //   return result.map((itemData) => fromMap(itemData)).toList();
  // }
}
