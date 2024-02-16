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
  ReceiptItemModel({
    required double quantity,
    int? id,
    required int subtotal,
    DateTime? createdAt,
    required int itemId,
    required String itemName,
    required String itemCode,
    required int itemPrice,
    int? receiptId,
  }) : super(
          id: id,
          quantity: quantity,
          subtotal: subtotal,
          createdAt: createdAt,
          itemId: itemId,
          itemName: itemName,
          itemCode: itemCode,
          itemPrice: itemPrice,
          receiptId: receiptId,
        );

  factory ReceiptItemModel.fromMap(Map<String, dynamic> map) {
    return ReceiptItemModel(
      id: map['_id'] != null ? map['_id'] as int : null,
      quantity: map['quantity'] as double,
      subtotal: map['subtotal'] as int,
      createdAt: map['createdat'] != null
          ? DateTime.parse(map['createdat']).toLocal()
          : null,
      itemId: map['moitm_id'] as int,
      itemName: map['itemname'] as String,
      itemCode: map['itemcode'] as String,
      itemPrice: map['itemprice'] as int,
      receiptId: map['receipt_id'] != null ? map['receipt_id'] as int : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'quantity': quantity,
      'subtotal': subtotal,
      'createdat': createdAt?.toUtc().toIso8601String(),
      'moitm_id': itemId,
      'itemname': itemName,
      'itemcode': itemCode,
      'itemprice': itemPrice,
      'receipt_id': receiptId,
    };
  }
}
