// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_repository.dart';

class GetCustomersUseCase
    implements UseCase<List<CustomerEntity>, GetCustomersUseCaseParams?> {
  final CustomerRepository _customerRepository;

  GetCustomersUseCase(this._customerRepository);

  @override
  Future<List<CustomerEntity>> call({GetCustomersUseCaseParams? params}) {
    return _customerRepository.getCustomers(
        searchKeyword: params?.searchKeyword,
        statusActive: params?.statusActive);
  }
}

class GetCustomersUseCaseParams {
  String? searchKeyword;
  int? statusActive;
  GetCustomersUseCaseParams({
    this.searchKeyword,
    this.statusActive,
  });
}
