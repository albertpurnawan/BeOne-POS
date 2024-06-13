import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_customers.dart';

part 'customers_state.dart';

class CustomersCubit extends Cubit<List<CustomerEntity>> {
  final GetCustomersUseCase _getCustomersUseCase;

  CustomersCubit(this._getCustomersUseCase) : super([]);

  void getActiveCustomers({required String searchKeyword}) async {
    final List<CustomerEntity> newState = await _getCustomersUseCase.call(
        params: GetCustomersUseCaseParams(
            searchKeyword: searchKeyword, statusActive: 1));
    emit(newState);
  }

  void clearCustomers() async {
    emit([]);
  }
}
