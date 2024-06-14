import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';

class GetItemUseCase implements UseCase<ItemEntity?, int> {
  final ItemRepository _itemRepository;

  GetItemUseCase(this._itemRepository);

  @override
  Future<ItemEntity?> call({int? params}) {
    return _itemRepository.getItem(params!);
  }
}
