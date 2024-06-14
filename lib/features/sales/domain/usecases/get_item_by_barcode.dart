import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';

class GetItemByBarcodeUseCase implements UseCase<ItemEntity?, String> {
  final ItemRepository _itemRepository;

  GetItemByBarcodeUseCase(this._itemRepository);

  @override
  Future<ItemEntity?> call({String? params}) {
    return _itemRepository.getItemByBarcode(params!);
  }
}
