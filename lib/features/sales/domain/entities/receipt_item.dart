// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';

class ReceiptItemEntity {
  double quantity;
  double totalGross;
  final ItemEntity itemEntity;
  double taxAmount;
  final double sellingPrice;
  double totalAmount;
  double totalSellBarcode;
  List<PromotionsEntity> promos;
  double? discAmount;
  double? discPrctg;
  double? discHeaderAmount;
  double? subtotalAfterDiscHeader;
  String? tohemId;
  String? remarks;
  int? qtyBarcode;
  String? refpos3;

  ReceiptItemEntity({
    required this.quantity,
    required this.totalGross,
    required this.itemEntity,
    required this.taxAmount,
    required this.sellingPrice,
    required this.totalAmount,
    required this.totalSellBarcode,
    required this.promos,
    this.discAmount,
    this.discPrctg,
    this.discHeaderAmount,
    this.subtotalAfterDiscHeader,
    this.tohemId,
    this.remarks,
    this.qtyBarcode,
    this.refpos3,
  });

  ReceiptItemEntity copyWith({
    double? quantity,
    double? totalGross,
    ItemEntity? itemEntity,
    double? taxAmount,
    double? sellingPrice,
    double? totalAmount,
    double? totalSellBarcode,
    List<PromotionsEntity>? promos,
    double? discAmount,
    double? discPrctg,
    double? discHeaderAmount,
    double? subtotalAfterDiscHeader,
    String? tohemId,
    String? remarks,
    int? qtyBarcode,
    String? refpos3,
  }) {
    return ReceiptItemEntity(
      quantity: quantity ?? this.quantity,
      totalGross: totalGross ?? this.totalGross,
      itemEntity: itemEntity ?? this.itemEntity,
      taxAmount: taxAmount ?? this.taxAmount,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      totalSellBarcode: totalSellBarcode ?? this.totalSellBarcode,
      promos: promos ?? this.promos,
      discAmount: discAmount ?? this.discAmount,
      discPrctg: discPrctg ?? this.discPrctg,
      discHeaderAmount: discHeaderAmount ?? this.discHeaderAmount,
      subtotalAfterDiscHeader: subtotalAfterDiscHeader ?? this.subtotalAfterDiscHeader,
      tohemId: tohemId ?? this.tohemId,
      remarks: remarks ?? this.remarks,
      qtyBarcode: qtyBarcode ?? this.qtyBarcode,
      refpos3: refpos3 ?? this.refpos3,
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
      'promos': promos.map((x) => x.toMap()).toList(),
      'discAmount': discAmount,
      'discPrctg': discPrctg,
      'discHeaderAmount': discHeaderAmount,
      'subtotalAfterDiscHeader': subtotalAfterDiscHeader,
      'tohemId': tohemId,
      'remarks': remarks,
      'qtyBarcode': qtyBarcode,
      'refpos3': refpos3,
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
      promos: List<PromotionsEntity>.from(
        (map['promos'] as List<int>).map<PromotionsEntity>(
          (x) => PromotionsEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
      discAmount: map['discAmount'] != null ? map['discAmount'] as double : null,
      discPrctg: map['discPrctg'] != null ? map['discPrctg'] as double : null,
      discHeaderAmount: map['discHeaderAmount'] != null ? map['discHeaderAmount'] as double : null,
      subtotalAfterDiscHeader: map['subtotalAfterDiscHeader'] != null ? map['subtotalAfterDiscHeader'] as double : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      qtyBarcode: map['qtyBarcode'] != null ? map['qtyBarcode'] as int : null,
      refpos3: map['refpos3'] != null ? map['refpos3'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReceiptItemEntity.fromJson(String source) =>
      ReceiptItemEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReceiptItemEntity(quantity: $quantity, totalGross: $totalGross, itemEntity: $itemEntity, taxAmount: $taxAmount, sellingPrice: $sellingPrice, totalAmount: $totalAmount, totalSellBarcode: $totalSellBarcode, promos: $promos, discAmount: $discAmount, discPrctg: $discPrctg, discHeaderAmount: $discHeaderAmount, subtotalAfterDiscHeader: $subtotalAfterDiscHeader, tohemId: $tohemId, remarks: $remarks, qtyBarcode: $qtyBarcode, refpos3: $refpos3)';
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
        other.totalSellBarcode == totalSellBarcode &&
        listEquals(other.promos, promos) &&
        other.discAmount == discAmount &&
        other.discPrctg == discPrctg &&
        other.discHeaderAmount == discHeaderAmount &&
        other.subtotalAfterDiscHeader == subtotalAfterDiscHeader &&
        other.tohemId == tohemId &&
        other.remarks == remarks &&
        other.qtyBarcode == qtyBarcode &&
        other.refpos3 == refpos3;
  }

  @override
  int get hashCode {
    return quantity.hashCode ^
        totalGross.hashCode ^
        itemEntity.hashCode ^
        taxAmount.hashCode ^
        sellingPrice.hashCode ^
        totalAmount.hashCode ^
        totalSellBarcode.hashCode ^
        promos.hashCode ^
        discAmount.hashCode ^
        discPrctg.hashCode ^
        discHeaderAmount.hashCode ^
        subtotalAfterDiscHeader.hashCode ^
        tohemId.hashCode ^
        remarks.hashCode ^
        qtyBarcode.hashCode ^
        refpos3.hashCode;
  }
}
