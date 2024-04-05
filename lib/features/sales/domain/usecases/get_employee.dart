import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/repository/employee_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetEmployeeUseCase implements UseCase<EmployeeEntity?, void> {
  final EmployeeRepository _employeeRepository;
  final SharedPreferences _prefs;

  GetEmployeeUseCase(this._employeeRepository, this._prefs);

  @override
  Future<EmployeeEntity?> call({void params}) async {
    // TODO: implement call
    final String? tohemId = _prefs.getString("tohemId");
    if (tohemId == null) return null;
    return await _employeeRepository.getEmployee(tohemId);
  }
}
