import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';
import 'package:sqflite/sqflite.dart';

class ItemRepositoryImpl implements ItemRepository {
  final AppDatabase _appDatabase;
  ItemRepositoryImpl(this._appDatabase);

  @override
  Future<List<ItemModel>> getItems({String? searchKeyword, String? pricelistId}) async {
    return _appDatabase.itemsDao.readAll(searchKeyword: searchKeyword);
  }

  @override
  Future<List<ItemModel>> getItemsByPricelist({String? searchKeyword, required String pricelistId}) async {
    return _appDatabase.itemsDao.readAllByPricelist(searchKeyword: searchKeyword, pricelistId: pricelistId);
  }

  @override
  Future<ItemEntity?> getItem(int id) {
    return _appDatabase.itemsDao.readItem(id);
  }

  @override
  Future<ItemEntity?> getItemByBarcode(String barcode) {
    return _appDatabase.itemsDao.readItemByBarcode(barcode);
  }

  @override
  Future<ItemEntity?> getItemWithAndConditions(Map<String, dynamic> conditions, Transaction? txn) {
    try {
      return _appDatabase.itemsDao.readItemWithAndCondition(conditions, txn);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ItemEntity?> getDownPayment() {
    return _appDatabase.itemsDao.getDownPayment();
  }
}
