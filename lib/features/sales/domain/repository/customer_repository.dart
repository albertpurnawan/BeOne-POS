import 'package:pos_fe/core/resources/data_state.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';

abstract class CustomerRepository {
  Future<List<CustomerEntity>> getCustomers({String? searchKeyword});

  // Future<ItemEntity?> getItemByBarcode(String barcode);

  // Future<ItemEntity?> getItem(int id);
}
