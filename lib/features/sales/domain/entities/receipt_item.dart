// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pos_fe/features/sales/domain/entities/item.dart';

class ReceiptItemEntity {
  int? id;
  double quantity;
  double subtotal;
  ItemEntity itemEntity;
  double taxAmount;

  ReceiptItemEntity({
    required this.id,
    required this.quantity,
    required this.subtotal,
    required this.itemEntity,
    required this.taxAmount,
  });

  ReceiptItemEntity copyWith({
    int? id,
    double? quantity,
    double? subtotal,
    ItemEntity? itemEntity,
    double? taxAmount,
  }) {
    return ReceiptItemEntity(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
      itemEntity: itemEntity ?? this.itemEntity,
      taxAmount: taxAmount ?? this.taxAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'quantity': quantity,
      'subtotal': subtotal,
      'itemEntity': itemEntity.toMap(),
      'taxAmount': taxAmount,
    };
  }

  factory ReceiptItemEntity.fromMap(Map<String, dynamic> map) {
    return ReceiptItemEntity(
      id: map['id'] != null ? map['id'] as int : null,
      quantity: map['quantity'] as double,
      subtotal: map['subtotal'] as double,
      itemEntity: ItemEntity.fromMap(map['itemEntity'] as Map<String, dynamic>),
      taxAmount: map['taxAmount'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReceiptItemEntity.fromJson(String source) =>
      ReceiptItemEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReceiptItemEntity(id: $id, quantity: $quantity, subtotal: $subtotal, itemEntity: $itemEntity, taxAmount: $taxAmount)';
  }

  @override
  bool operator ==(covariant ReceiptItemEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.quantity == quantity &&
        other.subtotal == subtotal &&
        other.itemEntity == itemEntity &&
        other.taxAmount == taxAmount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        quantity.hashCode ^
        subtotal.hashCode ^
        itemEntity.hashCode ^
        taxAmount.hashCode;
  }
}
