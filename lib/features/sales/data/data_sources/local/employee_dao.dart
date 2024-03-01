import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/currency.dart';
import 'package:pos_fe/features/sales/data/models/employee.dart';
import 'package:sqflite/sqflite.dart';

class EmployeeDao extends BaseDao<EmployeeModel> {
  EmployeeDao(Database db)
      : super(
            db: db,
            tableName: tableCurrencies,
            modelFields: CurrencyFields.values);

  @override
  Future<EmployeeModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? EmployeeModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<EmployeeModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => EmployeeModel.fromMap(itemData)).toList();
  }
}
