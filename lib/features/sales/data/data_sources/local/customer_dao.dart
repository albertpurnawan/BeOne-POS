import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/customer.dart';
import 'package:sqflite/sqflite.dart';

class CustomerDao extends BaseDao<CustomerModel> {
  CustomerDao(Database db)
      : super(
          db: db,
          tableName: tableCustomer,
          modelFields: CustomerFields.values,
        );

  @override
  Future<CustomerModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? CustomerModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<CustomerModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => CustomerModel.fromMap(itemData)).toList();
  }
}
