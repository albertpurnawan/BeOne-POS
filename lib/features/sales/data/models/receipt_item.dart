import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';

const String tableReceiptItems = 'receiptitems';

class ReceiptItemFields {
  static const List<String> values = [
    id,
    quantity,
    subtotal,
    createdAt,
    itemPrice,
    itemCode,
    itemName,
    itemId,
  ];

  static const String id = '_id';
  static const String quantity = "quantity";
  static const String subtotal = "subtotal";
  static const String createdAt = "createdat";
  static const String itemPrice = "itemprice";
  static const String itemName = "itemname";
  static const String itemCode = "itemcode";
  static const String itemId = "moitm_id";
  static const String receiptId = "receipt_id";
}

class ReceiptItemModel extends ReceiptItemEntity {
  ReceiptItemModel(
      {required super.id,
      required super.quantity,
      required super.subtotal,
      required super.itemEntity,
      required super.createdAt,
      required super.receiptId});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'quantity': quantity,
      'subtotal': subtotal,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'itemEntity': itemEntity.toMap(),
      'receiptId': receiptId,
    };
  }

  factory ReceiptItemModel.fromMap(Map<String, dynamic> map) {
    return ReceiptItemModel(
      id: map['id'] != null ? map['id'] as int : null,
      quantity: map['quantity'] as double,
      subtotal: map['subtotal'] as int,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      itemEntity: ItemEntity.fromMap(map['itemEntity'] as Map<String, dynamic>),
      receiptId: map['receiptId'] != null ? map['receiptId'] as int : null,
    );
  }
}
