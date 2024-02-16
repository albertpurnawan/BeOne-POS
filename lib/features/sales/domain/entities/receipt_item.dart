// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReceiptItemEntity {
  int? id;
  double quantity;
  int subtotal;
  DateTime? createdAt;
  int itemId;
  String itemName;
  String itemCode;
  int itemPrice;
  int? receiptId;

  ReceiptItemEntity({
    this.id,
    required this.quantity,
    required this.subtotal,
    this.createdAt,
    required this.itemId,
    required this.itemName,
    required this.itemCode,
    required this.itemPrice,
    this.receiptId,
  });

  ReceiptItemEntity copyWith({
    int? id,
    double? quantity,
    int? subtotal,
    DateTime? createdAt,
    int? itemId,
    String? itemName,
    String? itemCode,
    int? itemPrice,
    int? receiptId,
  }) {
    return ReceiptItemEntity(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
      createdAt: createdAt ?? this.createdAt,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      itemCode: itemCode ?? this.itemCode,
      itemPrice: itemPrice ?? this.itemPrice,
      receiptId: receiptId ?? this.receiptId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'quantity': quantity,
      'subtotal': subtotal,
      'createdAt': createdAt?.toIso8601String(),
      'itemId': itemId,
      'itemName': itemName,
      'itemCode': itemCode,
      'itemPrice': itemPrice,
      'receiptId': receiptId,
    };
  }

  factory ReceiptItemEntity.fromMap(Map<String, dynamic> map) {
    return ReceiptItemEntity(
      id: map['id'] != null ? map['id'] as int : null,
      quantity: map['quantity'] as double,
      subtotal: map['subtotal'] as int,
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      itemId: map['itemId'] as int,
      itemName: map['itemName'] as String,
      itemCode: map['itemCode'] as String,
      itemPrice: map['itemPrice'] as int,
      receiptId: map['receiptId'] != null ? map['receiptId'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReceiptItemEntity.fromJson(String source) =>
      ReceiptItemEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReceiptItemEntity(id: $id, quantity: $quantity, subtotal: $subtotal, createdAt: $createdAt, itemId: $itemId, itemName: $itemName, itemCode: $itemCode, itemPrice: $itemPrice, receiptId: $receiptId)';
  }

  @override
  bool operator ==(covariant ReceiptItemEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.quantity == quantity &&
        other.subtotal == subtotal &&
        other.createdAt == createdAt &&
        other.itemId == itemId &&
        other.itemName == itemName &&
        other.itemCode == itemCode &&
        other.itemPrice == itemPrice &&
        other.receiptId == receiptId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        quantity.hashCode ^
        subtotal.hashCode ^
        createdAt.hashCode ^
        itemId.hashCode ^
        itemName.hashCode ^
        itemCode.hashCode ^
        itemPrice.hashCode ^
        receiptId.hashCode;
  }
}
