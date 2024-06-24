import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/vouchers_selection.dart';
import 'package:sqflite/sqflite.dart';

class VouchersSelectionDao extends BaseDao<VouchersSelectionModel> {
  VouchersSelectionDao(Database db)
      : super(
          db: db,
          tableName: tableVouchersSelection,
          modelFields: VoucherSelectionFields.values,
        );

  @override
  Future<VouchersSelectionModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? VouchersSelectionModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<VouchersSelectionModel>> readAll({Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result
          .map((itemData) => VouchersSelectionModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(tableName);

      return result
          .map((itemData) => VouchersSelectionModel.fromMap(itemData))
          .toList();
    }
  }

  Future<VouchersSelectionModel> checkVoucher(String serialno,
      {Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return VouchersSelectionModel.fromMap(result.first);
    } else {
      final result = await db.query(tableName);

      return VouchersSelectionModel.fromMap(result.first);
    }
  }

  Future<List<VouchersSelectionModel>> readBytinv2Id(String tinv2id,
      {Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(
        tableName,
        columns: modelFields,
        where: 'tinv2id = ?',
        whereArgs: [tinv2id],
      );
      return result
          .map((itemData) => VouchersSelectionModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(
        tableName,
        columns: modelFields,
        where: 'tinv2id = ?',
        whereArgs: [tinv2id],
      );
      return result
          .map((itemData) => VouchersSelectionModel.fromMap(itemData))
          .toList();
    }
  }

  Future<List<VouchersSelectionModel>> readByTinv2IdAndTpmt3Id(
      String tinv2Id, String tpmt3Id,
      {Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName,
          columns: modelFields,
          where: 'tinv2id = ? AND tpmt3Id = ?',
          whereArgs: [tinv2Id, tpmt3Id]);
      return result
          .map((itemData) => VouchersSelectionModel.fromMap(itemData))
          .toList();
    } else {
      final result = await db.query(tableName,
          columns: modelFields,
          where: 'tinv2id = ? AND tpmt3Id = ?',
          whereArgs: [tinv2Id, tpmt3Id]);
      return result
          .map((itemData) => VouchersSelectionModel.fromMap(itemData))
          .toList();
    }
  }
}
