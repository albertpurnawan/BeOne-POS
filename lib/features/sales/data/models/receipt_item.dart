import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';

class ReceiptItemModel extends ReceiptItemEntity {
  ReceiptItemModel({
    required super.id,
    required super.quantity,
    required super.subtotal,
    required super.itemEntity,
    required super.taxAmount,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'quantity': quantity,
      'subtotal': subtotal,
      'itemEntity': itemEntity.toMap(),
      'taxamount': taxAmount,
    };
  }

  factory ReceiptItemModel.fromMap(Map<String, dynamic> map) {
    return ReceiptItemModel(
      id: map['id'] != null ? map['id'] as int : null,
      quantity: map['quantity'] as double,
      subtotal: map['subtotal'] as double,
      itemEntity: ItemEntity.fromMap(map['itemEntity'] as Map<String, dynamic>),
      taxAmount: map['taxamount'] as double,
    );
  }
}
