part of 'customers_cubit.dart';

sealed class CustomersState extends Equatable {
  const CustomersState();

  @override
  List<Object> get props => [];
}

final class CustomersInitial extends CustomersState {}
