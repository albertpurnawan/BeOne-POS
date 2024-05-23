import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';

abstract class ReceiptHelper {
  static ReceiptItemEntity updateReceiptItemAggregateFields(
      ReceiptItemEntity receiptItemEntity) {
    final newReceiptItem = receiptItemEntity.copyWith();
    final double priceQty =
        newReceiptItem.itemEntity.price * newReceiptItem.quantity;
    newReceiptItem.totalSellBarcode = priceQty;
    newReceiptItem.totalGross = newReceiptItem.itemEntity.includeTax == 1
        ? ((priceQty) * (100 / (100 + newReceiptItem.itemEntity.taxRate)))
        : priceQty;
    newReceiptItem.discPrctg =
        newReceiptItem.discAmount ?? 0 / newReceiptItem.totalGross;
    newReceiptItem.taxAmount = (newReceiptItem.totalGross -
            (newReceiptItem.discAmount ?? 0) -
            (newReceiptItem.discHeaderAmount ?? 0)) *
        (newReceiptItem.itemEntity.taxRate / 100);
    newReceiptItem.totalAmount = newReceiptItem.totalGross -
        (newReceiptItem.discAmount ?? 0) -
        (newReceiptItem.discHeaderAmount ?? 0) +
        newReceiptItem.taxAmount;
    return newReceiptItem;
  }

  static ReceiptItemEntity convertItemEntityToReceiptItemEntity(
      ItemEntity itemEntity, double quantity) {
    return ReceiptItemEntity(
      quantity: quantity,
      totalGross: 0,
      itemEntity: itemEntity,
      taxAmount: 0,
      sellingPrice: itemEntity.includeTax == 1
          ? itemEntity.price
          : itemEntity.dpp * ((100 + itemEntity.taxRate) / 100),
      totalAmount: 0,
      totalSellBarcode: 0,
      promos: [],
    );
  }

  static SplitListResult<ReceiptItemEntity> splitReceiptItemEntities(
      List<ReceiptItemEntity> receiptItemEntities, String barcode) {
    try {
      final SplitListResult<ReceiptItemEntity> splitListResult =
          Helpers.splitList<ReceiptItemEntity>(receiptItemEntities,
              (ReceiptItemEntity e) => e.itemEntity.barcode == barcode);
      List<ReceiptItemEntity> existItem = splitListResult.trueResult;
      if (existItem.length > 2) {
        throw "Receipt invalid, two same item barcodes found";
      }
      List<ReceiptItemEntity> otherItems = splitListResult.falseResult;

      return SplitListResult(otherItems, existItem);
    } catch (e) {
      rethrow;
    }
  }
}
