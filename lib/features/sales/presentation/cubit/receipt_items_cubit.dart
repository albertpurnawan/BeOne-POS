import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_by_barcode.dart';

part 'receipt_items_state.dart';

class ReceiptItemsCubit extends Cubit<List<ReceiptItemEntity>> {
  final GetItemByBarcodeUseCase _getItemByBarcodeUseCase;

  ReceiptItemsCubit(this._getItemByBarcodeUseCase) : super([]);

  void addOrUpdateReceiptItems(String itemBarcode, double quantity) async {
    if (quantity <= 0) {
      // Error
      print("quantity null");
      return;
    }

    final ItemEntity? itemEntity =
        await _getItemByBarcodeUseCase.call(params: itemBarcode);
    if (itemEntity == null) {
      print("itemEntity null");
      return;
    }

    List<ReceiptItemEntity> newState = [];
    bool isNewReceiptItem = true;
    for (final currentReceiptItem in state) {
      if (currentReceiptItem.itemCode == itemBarcode) {
        currentReceiptItem.quantity += quantity;
        isNewReceiptItem = false;
        newState.add(currentReceiptItem);
      } else {
        newState.add(currentReceiptItem);
      }
    }

    if (isNewReceiptItem) {
      newState.add(ReceiptItemEntity(
          quantity: quantity,
          subtotal: (quantity * itemEntity.price!).toInt(),
          itemId: itemEntity.id!,
          itemName: itemEntity.name!,
          itemCode: itemEntity.code!,
          itemPrice: itemEntity.price!));
    }

    emit(newState);
  }

  void clearReceiptItems() {
    emit([]);
  }
}
