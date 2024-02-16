// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';

class ReceiptEntity {
  List<ReceiptItemEntity> receiptItems;
  int totalPrice;
  DateTime? createdAt;

  ReceiptEntity({
    required this.receiptItems,
    required this.totalPrice,
    this.createdAt,
  });

  ReceiptEntity copyWith({
    List<ReceiptItemEntity>? receiptItems,
    int? totalPrice,
    DateTime? createdAt,
  }) {
    return ReceiptEntity(
      receiptItems: receiptItems ?? this.receiptItems,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'receiptItems': receiptItems.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory ReceiptEntity.fromMap(Map<String, dynamic> map) {
    return ReceiptEntity(
      receiptItems: List<ReceiptItemEntity>.from(
        (map['receiptItems'] as List<int>).map<ReceiptItemEntity>(
          (x) => ReceiptItemEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalPrice: map['totalPrice'] as int,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReceiptEntity.fromJson(String source) =>
      ReceiptEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ReceiptEntity(receiptItems: $receiptItems, totalPrice: $totalPrice, createdAt: $createdAt)';

  @override
  bool operator ==(covariant ReceiptEntity other) {
    if (identical(this, other)) return true;

    return listEquals(other.receiptItems, receiptItems) &&
        other.totalPrice == totalPrice &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode =>
      receiptItems.hashCode ^ totalPrice.hashCode ^ createdAt.hashCode;
}
