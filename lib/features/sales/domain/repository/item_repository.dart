import 'package:pos_fe/core/resources/data_state.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';

abstract class ItemRepository {
  Future<List<ItemEntity>> getItems();

  Future<ItemEntity?> getItemByBarcode(String barcode);

  Future<ItemEntity?> getItem(int id);
}
