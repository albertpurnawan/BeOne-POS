part of 'employees_cubit.dart';

sealed class EmployeesCubitState extends Equatable {
  const EmployeesCubitState();

  @override
  List<Object> get props => [];
}

final class EmployeesCubitInitial extends EmployeesCubitState {}
