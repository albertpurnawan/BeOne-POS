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

  Future<void> bulkCreate({required List<T> data, Transaction? txn}) async {
    if (txn != null) {
      final batch = txn.batch();

      batch.delete(tableName);

      for (final e in data) {
        batch.insert(tableName, e.toMap());
      }

      final res = await batch.commit(noResult: true);
      print(res.toString());
    } else {
      await db.transaction((txn) async {
        try {
          final batch = txn.batch();

          batch.delete(tableName);

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
  }

  Future<void> create({required T data, Transaction? txn}) async {
    if (txn != null) {
      final res = await txn.insert(tableName, data.toMap());
      print(res.toString());
    } else {
      final res = await db.insert(tableName, data.toMap());
      print(res.toString());
    }
  }

  Future<T?> readByDocId(String docId);

  Future<List<T>> readAll();

  Future<void> deleteAll({required T data, Transaction? txn}) async {
    await db.delete(tableName);
  }

  Future<void> update(
      {required String docId, required T data, Transaction? txn}) async {
    if (txn != null) {
      final res = await txn.update(tableName, data.toMap(),
          where: "docId = ?", whereArgs: [docId]);
    } else {
      final res = await db.update(tableName, data.toMap(),
          where: "docId = ?", whereArgs: [docId]);
    }
  }

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
