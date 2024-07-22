import 'package:pos_fe/features/sales/domain/entities/customer.dart';

abstract class CustomerRepository {
  Future<List<CustomerEntity>> getCustomers({String? searchKeyword, int? statusActive});
}
