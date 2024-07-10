// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

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
      log(res.toString());
    } else {
      await db.transaction((txn) async {
        try {
          final batch = txn.batch();

          for (final e in data) {
            batch.insert(tableName, e.toMap());
          }

          final res = await batch.commit(noResult: true);
          log(res.toString());
        } catch (e) {
          log(e.toString());
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

  Future<void> deleteAll() async {
    final List<String> tableNames = [
      'golog',
      'gopmt',
      'items',
      'mpad1',
      'phir1',
      'tastr',
      'tbitm',
      'tcsr1',
      'tcsr2',
      'tcurr',
      'tcus1',
      'tcus2',
      'thld1',
      'tinv1',
      'tinv2',
      'tinv3',
      'tinv4',
      'titt1',
      'tmpad',
      'tntzm',
      'toaut',
      'tobnk',
      'tobpt',
      'tocat',
      'tocrg',
      'tocry',
      'tocsr',
      'tocus',
      'toerr',
      'togen',
      'tohem',
      'toinv',
      'toitm',
      'toitt',
      'topdg',
      'topdi',
      'topln',
      'topmi',
      'topmt',
      'topos',
      'toprb',
      'toprc',
      'toprg',
      'toprk',
      'toprm',
      'toprn',
      'toprp',
      'toprr',
      'toprv',
      'topsb',
      'toptr',
      'torin',
      'torol',
      'tostr',
      'touom',
      'tousr',
      'tovat',
      'tovdg',
      'toven',
      'tozcd',
      'tpdg1',
      'tpdg2',
      'tpdg4',
      'tpdg5',
      'tpdi1',
      'tpdi2',
      'tpdi4',
      'tpdi5',
      'tphir',
      'tpitm',
      'tpln1',
      'tpln2',
      'tpln3',
      'tpln4',
      'tpmi1',
      'tpmi2',
      'tpmi4',
      'tpmi5',
      'tpmt1',
      'tpmt2',
      'tpmt3',
      'tpmt3',
      'tprb1',
      'tprb2',
      'tprb3',
      'tprb4',
      'tprb5',
      'tprc1',
      'tprc2',
      'tprc3',
      'tprc4',
      'tprc9',
      'tprg1',
      'tprg2',
      'tprg3',
      'tprg4',
      'tprk1',
      'tprk2',
      'tprk3',
      'tprk4',
      'tprk9',
      'tprn2',
      'tprn3',
      'tprn4',
      'tprn9',
      'tprop',
      'tprp1',
      'tprp2',
      'tprp3',
      'tprp4',
      'tprp8',
      'tprp9',
      'tprr2',
      'tprr3',
      'tprr4',
      'tprr9',
      'tpsb1',
      'tpsb2',
      'tpsb4',
      'trin1',
      'trin2',
      'trin3',
      'tritm',
      'tsitm',
      'tvcr9',
      'tvitm',
      'users',
      'queuedInvoiceDetails',
      'queuedInvoiceHeaders',
      'receipts',
      'receiptcontents',
      'receiptitems',
      'startShift',
      'closeShift',
    ];

    for (final tableName in tableNames) {
      await db.delete(tableName);
    }
  }

  Future<void> update({required String docId, required T data, Transaction? txn}) async {
    if (txn != null) {
      await txn.update(tableName, data.toMap(), where: "docId = ?", whereArgs: [docId]);
    } else {
      await db.update(tableName, data.toMap(), where: "docId = ?", whereArgs: [docId]);
    }
  }

  //TEMPORARY DELCREATE
  Future<void> resync({required List<T> data, Transaction? txn}) async {
    try {
      await deleteAll();
      await bulkCreate(data: data, txn: txn);
    } catch (err, stack) {
      log(err.toString());
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
