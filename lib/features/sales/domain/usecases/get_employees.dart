import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/repository/employee_repository.dart';

class GetEmployeesUseCase implements UseCase<List<EmployeeEntity>, String?> {
  final EmployeeRepository _employeeRepository;

  GetEmployeesUseCase(this._employeeRepository);

  @override
  Future<List<EmployeeEntity>> call({String? params}) {
    // TODO: implement call
    return _employeeRepository.getEmployees(searchKeyword: params);
  }
}
