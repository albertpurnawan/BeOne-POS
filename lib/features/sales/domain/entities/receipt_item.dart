// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pos_fe/features/sales/domain/entities/item.dart';

class ReceiptItemEntity {
  int? id;
  double quantity;
  int subtotal;
  DateTime? createdAt;
  ItemEntity itemEntity;
  int? receiptId;

  ReceiptItemEntity({
    required this.id,
    required this.quantity,
    required this.subtotal,
    required this.createdAt,
    required this.itemEntity,
    required this.receiptId,
  });

  ReceiptItemEntity copyWith({
    int? id,
    double? quantity,
    int? subtotal,
    DateTime? createdAt,
    ItemEntity? itemEntity,
    int? receiptId,
  }) {
    return ReceiptItemEntity(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
      createdAt: createdAt ?? this.createdAt,
      itemEntity: itemEntity ?? this.itemEntity,
      receiptId: receiptId ?? this.receiptId,
    );
  }

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

  factory ReceiptItemEntity.fromMap(Map<String, dynamic> map) {
    return ReceiptItemEntity(
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

  String toJson() => json.encode(toMap());

  factory ReceiptItemEntity.fromJson(String source) =>
      ReceiptItemEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReceiptItemEntity(id: $id, quantity: $quantity, subtotal: $subtotal, createdAt: $createdAt, itemEntity: $itemEntity, receiptId: $receiptId)';
  }

  @override
  bool operator ==(covariant ReceiptItemEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.quantity == quantity &&
        other.subtotal == subtotal &&
        other.createdAt == createdAt &&
        other.itemEntity == itemEntity &&
        other.receiptId == receiptId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        quantity.hashCode ^
        subtotal.hashCode ^
        createdAt.hashCode ^
        itemEntity.hashCode ^
        receiptId.hashCode;
  }
}
