import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_items_by_pricelist.dart';

part 'items_state.dart';

class ItemsCubit extends Cubit<List<ItemEntity>> {
  final GetItemsByPricelistUseCase _getItemsByPricelistUseCase;

  ItemsCubit(this._getItemsByPricelistUseCase) : super([]);

  Future<void> getItems({required String searchKeyword, required CustomerEntity customerEntity}) async {
    log("getItems $searchKeyword $customerEntity");
    final List<ItemEntity> newState = await _getItemsByPricelistUseCase.call(
        params: GetItemsByPricelistUseCaseParams(customerEntity: customerEntity, searchKeyword: searchKeyword));
    emit(newState);
  }

  void clearItems() async {
    emit([]);
  }
}
