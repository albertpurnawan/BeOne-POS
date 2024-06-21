import 'package:pos_fe/features/sales/domain/entities/item_master.dart';

abstract class ItemMasterRepository {
  Future<List<ItemMasterEntity>> getItemMastersByCategory(String tocatId);
}
