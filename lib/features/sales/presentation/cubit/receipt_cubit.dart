import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_by_barcode.dart';

part 'receipt_state.dart';

class ReceiptCubit extends Cubit<ReceiptEntity> {
  final GetItemByBarcodeUseCase _getItemByBarcodeUseCase;

  ReceiptCubit(this._getItemByBarcodeUseCase)
      : super(ReceiptEntity(receiptItems: [], totalPrice: 0));

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

    List<ReceiptItemEntity> newReceiptItems = [];
    int totalPrice = 0;
    bool isNewReceiptItem = true;
    for (final currentReceiptItem in state.receiptItems) {
      if (currentReceiptItem.itemEntity.barcode == itemBarcode) {
        currentReceiptItem.quantity += quantity;
        currentReceiptItem.subtotal =
            (currentReceiptItem.quantity * itemEntity.price).toInt();
        isNewReceiptItem = false;
        newReceiptItems.add(currentReceiptItem);
      } else {
        newReceiptItems.add(currentReceiptItem);
      }
      totalPrice += currentReceiptItem.subtotal;
    }

    if (isNewReceiptItem) {
      final int subtotal = (quantity * itemEntity.price).toInt();
      newReceiptItems.add(ReceiptItemEntity(
        quantity: quantity,
        subtotal: subtotal,
        itemEntity: itemEntity,
        id: null,
        createdAt: null,
        receiptId: null,
      ));
      totalPrice += subtotal;
    }

    final ReceiptEntity newState =
        ReceiptEntity(receiptItems: newReceiptItems, totalPrice: totalPrice);
    emit(newState);
  }

  void updateQuantity(ReceiptItemEntity receiptItemEntity, double quantity) {
    List<ReceiptItemEntity> newReceiptItems = [];
    int totalPrice = 0;

    for (final currentReceiptItem in state.receiptItems) {
      if (currentReceiptItem.itemEntity.barcode ==
          receiptItemEntity.itemEntity.barcode) {
        currentReceiptItem.quantity += quantity;
        currentReceiptItem.subtotal =
            (currentReceiptItem.quantity * receiptItemEntity.itemEntity.price)
                .toInt();
        newReceiptItems.add(currentReceiptItem);
      } else {
        newReceiptItems.add(currentReceiptItem);
      }
      totalPrice += currentReceiptItem.subtotal;
    }

    final ReceiptEntity newState =
        ReceiptEntity(receiptItems: newReceiptItems, totalPrice: totalPrice);
    emit(newState);
  }

  void clearReceiptItems() {
    emit(ReceiptEntity(receiptItems: [], totalPrice: 0));
  }
}
