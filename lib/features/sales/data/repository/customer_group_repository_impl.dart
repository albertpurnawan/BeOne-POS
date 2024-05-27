import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/customer_group.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_group_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_repository.dart';

class CustomerGroupRepositoryImpl implements CustomerGroupRepository {
  final AppDatabase _appDatabase;
  CustomerGroupRepositoryImpl(this._appDatabase);

  @override
  Future<CustomerGroupEntity?> getCustomerGroup(String docId) async {
    // TODO: implement getCustomers
    return await _appDatabase.customerGroupDao.readByDocId(docId, null);
  }
}
