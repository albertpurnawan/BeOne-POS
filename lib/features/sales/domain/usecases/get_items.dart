import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';

class GetItemsUseCase implements UseCase<List<ItemEntity>, void> {
  final ItemRepository _itemRepository;

  GetItemsUseCase(this._itemRepository);

  @override
  Future<List<ItemEntity>> call({void params}) {
    // TODO: implement call
    return _itemRepository.getItems();
  }
}
