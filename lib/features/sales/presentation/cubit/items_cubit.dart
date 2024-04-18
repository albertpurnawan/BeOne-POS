import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_items.dart';

part 'items_state.dart';

class ItemsCubit extends Cubit<List<ItemEntity>> {
  final GetItemsUseCase _getItemsUseCase;

  ItemsCubit(this._getItemsUseCase) : super([]);

  void getItems({required String searchKeyword}) async {
    final List<ItemEntity> newState =
        await _getItemsUseCase.call(params: searchKeyword);
    emit(newState);
  }

  void clearItems() async {
    emit([]);
  }
}
