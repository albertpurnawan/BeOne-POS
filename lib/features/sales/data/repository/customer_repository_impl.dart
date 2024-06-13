import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final AppDatabase _appDatabase;
  CustomerRepositoryImpl(this._appDatabase);

  @override
  Future<List<CustomerEntity>> getCustomers(
      {String? searchKeyword, int? statusActive}) {
    // TODO: implement getCustomers
    return _appDatabase.customerDao
        .readAll(searchKeyword: searchKeyword, statusActive: statusActive);
  }
}
