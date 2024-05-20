import 'package:flutter/material.dart';
import 'package:pos_fe/core/resources/error_handler.dart';
import 'package:pos_fe/core/resources/result.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
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
      // Declare variables
      final ItemEntity? itemEntity;
      ReceiptItemEntity receiptItemEntity;

      // Validate params
      if (params == null) throw "Params required";
      if (params.barcode == null && params.itemEntity == null) {
        throw "Item barcode or item required";
      }

      // Get item entity and validate
      if (params.barcode != null) {
        itemEntity =
            await _getItemByBarcodeUseCase.call(params: params.barcode);
      } else {
        itemEntity = params.itemEntity;
      }
      if (itemEntity == null) throw "Item not found";

      // Convert item entity to receipt item entity
      receiptItemEntity = ReceiptHelper.convertItemEntityToReceiptItemEntity(
          itemEntity, params.quantity);

      // Handle open price
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
