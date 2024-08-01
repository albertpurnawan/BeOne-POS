import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/customer.dart';
import 'package:pos_fe/features/sales/data/models/customer_cst.dart';
import 'package:sqflite/sqflite.dart';

class CustomerDao extends BaseDao<CustomerModel> {
  CustomerDao(Database db) : super(db: db, tableName: tableCustomer, modelFields: CustomerCstFields.values);

  @override
  Future<CustomerModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? CustomerModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<CustomerModel>> readAll({String? searchKeyword, Transaction? txn, int? statusActive}) async {
    String where =
        "(${CustomerFields.custName} LIKE ? OR ${CustomerFields.phone} LIKE ? OR ${CustomerFields.custCode} LIKE ?)";
    List<dynamic> whereArgs = ["%$searchKeyword%", "%$searchKeyword%", "%$searchKeyword%"];

    if (statusActive != null) {
      where += " AND ${CustomerFields.statusActive} = ?";
      whereArgs.add(statusActive);
    }

    final result = await db.query(tableName, where: where, whereArgs: whereArgs);

    return result.map((itemData) => CustomerModel.fromMap(itemData)).toList();
  }

  Future<CustomerModel?> readByCustCode(String custCode, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'custcode = ?',
      whereArgs: [custCode],
    );

    return res.isNotEmpty ? CustomerModel.fromMap(res[0]) : null;
  }
}
