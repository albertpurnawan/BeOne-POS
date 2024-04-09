// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
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

      for (final e in data) {
        batch.insert(tableName, e.toMap());
      }

      final res = await batch.commit(noResult: true);
      print(res.toString());
    } else {
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
  }

  Future<void> create({required T data, Transaction? txn}) async {
    if (txn != null) {
      await txn.insert(tableName, data.toMap());
    } else {
      await db.insert(tableName, data.toMap());
    }
  }

  Future<T?> readByDocId(String docId, Transaction? txn);

  Future<List<T>> readAll({Transaction? txn});

  Future<void> deleteAll({required List<T> data, Transaction? txn}) async {
    await db.delete(tableName);
  }

  Future<void> update(
      {required String docId, required T data, Transaction? txn}) async {
    if (txn != null) {
      await txn.update(tableName, data.toMap(),
          where: "docId = ?", whereArgs: [docId]);
    } else {
      await db.update(tableName, data.toMap(),
          where: "docId = ?", whereArgs: [docId]);
    }
  }

  //TEMPORARY DELCREATE
  Future<void> resync({required List<T> data, Transaction? txn}) async {
    try {
      await deleteAll(data: data, txn: txn);
      await bulkCreate(data: data, txn: txn);
    } catch (err, stack) {
      print(err);
      debugPrintStack(stackTrace: stack);
      rethrow;
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
