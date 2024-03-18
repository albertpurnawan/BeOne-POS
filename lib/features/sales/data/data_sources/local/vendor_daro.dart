import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/vendor.dart';
import 'package:sqflite/sqflite.dart';

class VendorDao extends BaseDao<VendorModel> {
  VendorDao(Database db)
      : super(db: db, tableName: tableVendor, modelFields: VendorFields.values);

  @override
  Future<VendorModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? VendorModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<VendorModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => VendorModel.fromMap(itemData)).toList();
  }
}
