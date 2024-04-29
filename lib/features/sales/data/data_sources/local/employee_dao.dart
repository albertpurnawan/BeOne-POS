import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/employee.dart';
import 'package:sqflite/sqflite.dart';

class EmployeeDao extends BaseDao<EmployeeModel> {
  EmployeeDao(Database db)
      : super(
            db: db,
            tableName: tableEmployee,
            modelFields: EmployeeFields.values);

  @override
  Future<EmployeeModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? EmployeeModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<EmployeeModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await db.query(tableName);

    return result.map((itemData) => EmployeeModel.fromMap(itemData)).toList();
  }

  Future<EmployeeModel?> readByEmpCode(String empCode, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;

    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'empcode = ?',
      whereArgs: [empCode],
    );

    return res.isNotEmpty ? EmployeeModel.fromMap(res[0]) : null;
  }
}
