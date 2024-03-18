import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/customer_cst.dart';
import 'package:sqflite/sqflite.dart';

class CustomerCstDao extends BaseDao<CustomerCstModel> {
  CustomerCstDao(Database db)
      : super(
            db: db,
            tableName: tableCustomerCst,
            modelFields: CustomerCstFields.values);

  @override
  Future<CustomerCstModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? CustomerCstModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<CustomerCstModel>> readAll({String? searchKeyword}) async {
    final result = await db.query(tableName,
        where:
            "${CustomerCstFields.custName} LIKE ? OR ${CustomerCstFields.phone} LIKE ?",
        whereArgs: ["%$searchKeyword%", "%$searchKeyword%"]);

    return result
        .map((itemData) => CustomerCstModel.fromMap(itemData))
        .toList();
  }
}
