import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';

class GetDownPaymentUseCase implements UseCase<ItemEntity?, void> {
  final ItemRepository _itemRepository;

  GetDownPaymentUseCase(this._itemRepository);

  @override
  Future<ItemEntity?> call({void params}) {
    return _itemRepository.getDownPayment();
  }
}
