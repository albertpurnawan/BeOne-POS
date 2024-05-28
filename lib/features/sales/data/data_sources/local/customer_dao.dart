import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/customer.dart';
import 'package:pos_fe/features/sales/data/models/customer_cst.dart';
import 'package:sqflite/sqflite.dart';

class CustomerDao extends BaseDao<CustomerModel> {
  CustomerDao(Database db)
      : super(
            db: db,
            tableName: tableCustomer,
            modelFields: CustomerCstFields.values);

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
  Future<List<CustomerModel>> readAll(
      {String? searchKeyword, Transaction? txn}) async {
    final result = await db.query(tableName,
        where:
            "${CustomerFields.custName} LIKE ? OR ${CustomerFields.phone} LIKE ?",
        whereArgs: ["%$searchKeyword%", "%$searchKeyword%"]);

    return result.map((itemData) => CustomerModel.fromMap(itemData)).toList();
  }

  Future<CustomerModel?> readByCustCode(
      String custCode, Transaction? txn) async {
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
