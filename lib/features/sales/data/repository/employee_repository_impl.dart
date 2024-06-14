import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/repository/employee_repository.dart';

class EmployeeRepositoryImpl extends EmployeeRepository {
  final AppDatabase _appDatabase;
  EmployeeRepositoryImpl(this._appDatabase);

  @override
  Future<EmployeeEntity?> getEmployee(String docId) {
    return _appDatabase.employeeDao.readByDocId(docId, null);
  }

  @override
  Future<List<EmployeeEntity>> getEmployees({String? searchKeyword}) {
    return _appDatabase.employeeDao
        .readAllWithSearch(searchKeyword: searchKeyword);
  }
}
