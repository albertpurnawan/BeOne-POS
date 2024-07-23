// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/pos_paramater_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/store_master_repository.dart';

class GetItemsByPricelistUseCase implements UseCase<List<ItemEntity>, GetItemsByPricelistUseCaseParams?> {
  final ItemRepository _itemRepository;
  final POSParameterRepository _posParameterRepository;
  final StoreMasterRepository _storeMasterRepository;

  GetItemsByPricelistUseCase(this._itemRepository, this._posParameterRepository, this._storeMasterRepository);

  @override
  Future<List<ItemEntity>> call({GetItemsByPricelistUseCaseParams? params}) async {
    try {
      if (params == null) throw "GetItemsByPricelistUseCaseParams requires params";
      List<ItemEntity> result = [];

      final POSParameterEntity posParameterEntity = await _posParameterRepository.getPosParameter();
      if (posParameterEntity.tostrId == null) throw "Invalid POS Parameter";
      final StoreMasterEntity? storeMasterEntity =
          await _storeMasterRepository.getStoreMaster(posParameterEntity.tostrId!);
      if (storeMasterEntity == null) throw "Store master not found";
      final List<ItemEntity> normalPriceItems = await _itemRepository.getItemsByPricelist(
        searchKeyword: params.searchKeyword,
        pricelistId: storeMasterEntity.toplnId!,
      );
      result.addAll(normalPriceItems);

      if (params.customerEntity.toplnId != null) {
        final List<ItemEntity> memberPriceItems = await _itemRepository.getItemsByPricelist(
            searchKeyword: params.searchKeyword, pricelistId: params.customerEntity.toplnId!);
        for (final memberPriceItem in memberPriceItems) {
          result = result.where((e) => e.barcode != memberPriceItem.barcode).toList() + [memberPriceItem];
        }
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}

class GetItemsByPricelistUseCaseParams {
  final String? searchKeyword;
  final CustomerEntity customerEntity;

  GetItemsByPricelistUseCaseParams({
    this.searchKeyword,
    required this.customerEntity,
  });
}
