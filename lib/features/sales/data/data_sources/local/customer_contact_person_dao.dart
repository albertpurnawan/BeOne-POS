import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/customer_contact_person.dart';
import 'package:sqflite/sqflite.dart';

class CustomerContactPersonDao extends BaseDao<CustomerContactPersonModel> {
  CustomerContactPersonDao(Database db)
      : super(
          db: db,
          tableName: tableCustomerContactPerson,
          modelFields: CustomerContactPersonFields.values,
        );

  @override
  Future<CustomerContactPersonModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? CustomerContactPersonModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<CustomerContactPersonModel>> readAll() async {
    final result = await db.query(tableName);

    return result
        .map((itemData) => CustomerContactPersonModel.fromMap(itemData))
        .toList();
  }
}
