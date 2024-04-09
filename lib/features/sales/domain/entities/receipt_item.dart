// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pos_fe/features/sales/domain/entities/item.dart';

class ReceiptItemEntity {
  double quantity;
  double totalGross;
  final ItemEntity itemEntity;
  double taxAmount;
  final double sellingPrice;
  double totalAmount;
  double totalSellBarcode;

  ReceiptItemEntity({
    required this.quantity,
    required this.totalGross,
    required this.itemEntity,
    required this.taxAmount,
    required this.sellingPrice,
    required this.totalAmount,
    required this.totalSellBarcode,
  });

  ReceiptItemEntity copyWith({
    double? quantity,
    double? totalGross,
    ItemEntity? itemEntity,
    double? taxAmount,
    double? sellingPrice,
    double? totalAmount,
    double? totalSellBarcode,
  }) {
    return ReceiptItemEntity(
      quantity: quantity ?? this.quantity,
      totalGross: totalGross ?? this.totalGross,
      itemEntity: itemEntity ?? this.itemEntity,
      taxAmount: taxAmount ?? this.taxAmount,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      totalSellBarcode: totalSellBarcode ?? this.totalSellBarcode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quantity': quantity,
      'totalGross': totalGross,
      'itemEntity': itemEntity.toMap(),
      'taxAmount': taxAmount,
      'sellingPrice': sellingPrice,
      'totalAmount': totalAmount,
      'totalSellBarcode': totalSellBarcode,
    };
  }

  factory ReceiptItemEntity.fromMap(Map<String, dynamic> map) {
    return ReceiptItemEntity(
      quantity: map['quantity'] as double,
      totalGross: map['totalGross'] as double,
      itemEntity: ItemEntity.fromMap(map['itemEntity'] as Map<String, dynamic>),
      taxAmount: map['taxAmount'] as double,
      sellingPrice: map['sellingPrice'] as double,
      totalAmount: map['totalAmount'] as double,
      totalSellBarcode: map['totalSellBarcode'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReceiptItemEntity.fromJson(String source) =>
      ReceiptItemEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReceiptItemEntity(quantity: $quantity, totalGross: $totalGross, itemEntity: $itemEntity, taxAmount: $taxAmount, sellingPrice: $sellingPrice, totalAmount: $totalAmount, totalSellBarcode: $totalSellBarcode)';
  }

  @override
  bool operator ==(covariant ReceiptItemEntity other) {
    if (identical(this, other)) return true;

    return other.quantity == quantity &&
        other.totalGross == totalGross &&
        other.itemEntity == itemEntity &&
        other.taxAmount == taxAmount &&
        other.sellingPrice == sellingPrice &&
        other.totalAmount == totalAmount &&
        other.totalSellBarcode == totalSellBarcode;
  }

  @override
  int get hashCode {
    return quantity.hashCode ^
        totalGross.hashCode ^
        itemEntity.hashCode ^
        taxAmount.hashCode ^
        sellingPrice.hashCode ^
        totalAmount.hashCode ^
        totalSellBarcode.hashCode;
  }
}
