import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/vendor_group.dart';
import 'package:sqflite/sqflite.dart';

class VendorGroupDao extends BaseDao<VendorGroupModel> {
  VendorGroupDao(Database db)
      : super(
          db: db,
          tableName: tableVendorGroup,
          modelFields: VendorGroupFields.values,
        );

  @override
  Future<VendorGroupModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? VendorGroupModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<VendorGroupModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => VendorGroupModel.fromMap(itemData))
        .toList();
  }
}
