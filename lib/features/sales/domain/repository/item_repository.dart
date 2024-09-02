import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:sqflite/sqflite.dart';

abstract class ItemRepository {
  Future<List<ItemEntity>> getItems({String? searchKeyword});

  Future<List<ItemEntity>> getItemsByPricelist({String? searchKeyword, required String pricelistId});

  Future<ItemEntity?> getItemByBarcode(String barcode);

  Future<ItemEntity?> getItem(int id);

  Future<ItemEntity?> getDownPayment();

  Future<ItemEntity?> getItemWithAndConditions(Map<String, dynamic> conditions, Transaction? txn);
}
