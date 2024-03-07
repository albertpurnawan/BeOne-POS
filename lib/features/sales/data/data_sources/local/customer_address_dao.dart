import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/customer_address.dart';
import 'package:sqflite/sqflite.dart';

class CustomerAddressDao extends BaseDao<CustomerAddressModel> {
  CustomerAddressDao(Database db)
      : super(
          db: db,
          tableName: tableCustomerAddress,
          modelFields: CustomerAddressFields.values,
        );

  @override
  Future<CustomerAddressModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? CustomerAddressModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<CustomerAddressModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => CustomerAddressModel.fromMap(itemData))
        .toList();
  }
}
