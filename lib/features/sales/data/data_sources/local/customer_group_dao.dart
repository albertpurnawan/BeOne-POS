import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/customer.dart';
import 'package:pos_fe/features/sales/data/models/customer_group.dart';
import 'package:sqflite/sqflite.dart';

class CustomerGroupDao extends BaseDao<CustomerGroupModel> {
  CustomerGroupDao(Database db)
      : super(
          db: db,
          tableName: tableCustomerGroup,
          modelFields: CustomerFields.values,
        );

  @override
  Future<CustomerGroupModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? CustomerGroupModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<CustomerGroupModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => CustomerGroupModel.fromMap(itemData))
        .toList();
  }
}
