import 'package:flutter/material.dart';
import 'package:pos_fe/core/resources/error_handler.dart';
import 'package:pos_fe/core/resources/result.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_by_barcode.dart';

class HandleNewReceiptItemUseCase
    implements
        UseCase<List<ReceiptItemEntity>?, HandleNewReceiptItemUseCaseParams?> {
  GetItemByBarcodeUseCase _getItemByBarcodeUseCase;

  HandleNewReceiptItemUseCase(this._getItemByBarcodeUseCase);

  @override
  Future<List<ReceiptItemEntity>?> call(
      {HandleNewReceiptItemUseCaseParams? params}) async {
    // TODO: implement call
    try {
      final ItemEntity? itemEntity;
      final ReceiptItemEntity receiptItemEntity;

      if (params == null) throw "Params required";
      if (params.barcode == null && params.itemEntity == null) {
        throw "Item barcode or item required";
      }

      if (params.barcode != null) {
        itemEntity =
            await _getItemByBarcodeUseCase.call(params: params.barcode);
      } else {
        itemEntity = params.itemEntity;
      }
      if (itemEntity == null) throw "Item not found";

      receiptItemEntity = ReceiptItemEntity(
          quantity: params.quantity,
          totalGross: 0,
          itemEntity: itemEntity,
          taxAmount: 0,
          sellingPrice: itemEntity.price,
          totalAmount: 0,
          totalSellBarcode: 0,
          promos: []);

      if (itemEntity.openPrice == 1) {
      } else {}
      ;
    } catch (e) {
      rethrow;
    }
  }
}

class HandleNewReceiptItemUseCaseParams {
  final String? barcode;
  final ItemEntity? itemEntity;
  final double quantity;
  final BuildContext context;

  HandleNewReceiptItemUseCaseParams({
    required this.barcode,
    required this.itemEntity,
    required this.quantity,
    required this.context,
  });
}
