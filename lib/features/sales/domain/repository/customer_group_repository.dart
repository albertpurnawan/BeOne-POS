import 'package:pos_fe/features/sales/data/models/currency.dart';
import 'package:pos_fe/features/sales/domain/entities/customer_group.dart';

abstract class CustomerGroupRepository {
  Future<CustomerGroupEntity?> getCustomerGroup(String docId);
}
