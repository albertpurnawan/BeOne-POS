import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';

class ReceiptItemModel extends ReceiptItemEntity {
  ReceiptItemModel({
    required super.quantity,
    required super.totalGross,
    required super.itemEntity,
    required super.taxAmount,
    required super.sellingPrice,
    required super.totalAmount,
    required super.totalSellBarcode,
    required super.promos,
    super.discAmount,
    super.tohemId,
    super.remarks,
    super.refpos2,
    super.refpos3,
  });
}
