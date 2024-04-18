import 'package:pos_fe/features/sales/domain/entities/item.dart';

abstract class ItemRepository {
  Future<List<ItemEntity>> getItems({String? searchKeyword});

  Future<ItemEntity?> getItemByBarcode(String barcode);

  Future<ItemEntity?> getItem(int id);
}
