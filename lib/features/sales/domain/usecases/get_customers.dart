import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_repository.dart';

class GetCustomersUseCase implements UseCase<List<CustomerEntity>, String?> {
  final CustomerRepository _customerRepository;

  GetCustomersUseCase(this._customerRepository);

  @override
  Future<List<CustomerEntity>> call({String? params}) {
    // TODO: implement call
    return _customerRepository.getCustomers(searchKeyword: params);
  }
}
