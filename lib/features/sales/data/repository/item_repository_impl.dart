import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';

class ItemRepositoryImpl implements ItemRepository {
  final AppDatabase _appDatabase;
  ItemRepositoryImpl(this._appDatabase);

  @override
  Future<List<ItemModel>> getItems() async {
    // TODO: implement getItems
    // try {
    //   final httpResponse = await _itemService.getItems();

    //   if (httpResponse.response.statusCode == HttpStatus.ok) {
    //     return DataSuccess(httpResponse.data);
    //   } else {
    //     return DataFailed(
    //       DioException(
    //         requestOptions: httpResponse.response.requestOptions,
    //         error: httpResponse.response.statusMessage,
    //         response: httpResponse.response,
    //         type: DioExceptionType.badResponse,
    //       ),
    //     );
    //   }
    // } on DioException catch (e) {
    //   return DataFailed(e);
    // }
    return _appDatabase.itemsDao.readItems();
  }

  @override
  Future<ItemEntity?> getItem(int id) {
    // TODO: implement getItem
    return _appDatabase.itemsDao.readItem(id);
  }

  @override
  Future<ItemEntity?> getItemByBarcode(String barcode) {
    // TODO: implement getItemByBarcode
    return _appDatabase.itemsDao.readItemByBarcode(barcode);
  }
}
