import 'dart:developer';

import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:sqflite/sqflite.dart';

class POSParameterDao extends BaseDao<POSParameterModel> {
  POSParameterDao(Database db)
      : super(
          db: db,
          tableName: tablePOSParameter,
          modelFields: POSParameterFields.values,
        );

  @override
  Future<POSParameterModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? POSParameterModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<POSParameterModel>> readAll({Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);
      log("$result ressuuuuuult");
      return result
          .map((itemData) => POSParameterModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(tableName);
      log("$result ressuuuuuult");
      return result
          .map((itemData) => POSParameterModel.fromMap(itemData))
          .toList();
    }
  }
}
