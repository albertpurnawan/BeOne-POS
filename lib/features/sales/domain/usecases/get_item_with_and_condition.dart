import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';

class GetItemWithAndConditionUseCase implements UseCase<ItemEntity?, Map<String, dynamic>> {
  final ItemRepository _itemRepository;

  GetItemWithAndConditionUseCase(this._itemRepository);

  @override
  Future<ItemEntity?> call({Map<String, dynamic>? params}) {
    return _itemRepository.getItemWithAndConditions(params!, null);
  }
}
