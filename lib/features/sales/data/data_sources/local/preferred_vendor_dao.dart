import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/preferred_vendor.dart';
import 'package:sqflite/sqflite.dart';

class PreferredVendorDao extends BaseDao<PreferredVendorModel> {
  PreferredVendorDao(Database db)
      : super(
            db: db,
            tableName: tablePreferredVendor,
            modelFields: PreferredVendorFields.values);

  @override
  Future<PreferredVendorModel?> readByDocId(
      String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PreferredVendorModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PreferredVendorModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result
        .map((itemData) => PreferredVendorModel.fromMap(itemData))
        .toList();
  }
}
