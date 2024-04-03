import 'package:pos_fe/features/sales/domain/entities/employee.dart';

abstract class EmployeeRepository {
  Future<EmployeeEntity?> getEmployee(String docId);
}
