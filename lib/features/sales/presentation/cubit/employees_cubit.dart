import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_employees.dart';

part 'employees_state.dart';

class EmployeesCubit extends Cubit<List<EmployeeEntity>> {
  final GetEmployeesUseCase _getEmployeesUseCase;

  EmployeesCubit(this._getEmployeesUseCase) : super([]);

  void getEmployees({required String searchKeyword}) async {
    final List<EmployeeEntity> newState =
        await _getEmployeesUseCase.call(params: searchKeyword);
    emit(newState);
  }

  void clearEmployees() async {
    emit([]);
  }
}
