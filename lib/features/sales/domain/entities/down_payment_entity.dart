// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pos_fe/features/sales/domain/entities/down_payment_items_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';

class DownPaymentEntity {
  final String? refpos2;
  final String? toinvDocId;
  final String? salesTohemId;
  final String? remarks;
  final double amount;
  final String? refpos3;
  final List<DownPaymentItemsEntity>? tinv7;
  final List<ItemEntity>? tempItems;
  final bool? isReceive;
  final bool? isSelected;

  DownPaymentEntity({
    this.refpos2,
    this.toinvDocId,
    required this.amount,
    this.salesTohemId,
    this.remarks,
    this.refpos3,
    this.tinv7,
    this.tempItems,
    this.isReceive,
    this.isSelected,
  });

  DownPaymentEntity copyWith({
    String? refpos2,
    String? toinvDocId,
    double? amount,
    String? salesTohemId,
    String? remarks,
    String? refpos3,
    List<DownPaymentItemsEntity>? tinv7,
    List<ItemEntity>? tempItems,
    bool? isReceive,
    bool? isSelected,
  }) {
    return DownPaymentEntity(
      refpos2: refpos2 ?? this.refpos2,
      toinvDocId: toinvDocId ?? this.toinvDocId,
      amount: amount ?? this.amount,
      salesTohemId: salesTohemId ?? this.salesTohemId,
      remarks: remarks ?? this.remarks,
      refpos3: refpos3 ?? this.refpos3,
      tinv7: tinv7 ?? this.tinv7,
      tempItems: tempItems ?? this.tempItems,
      isReceive: isReceive ?? this.isReceive,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'refpos2': refpos2,
      'toinvDocId': toinvDocId,
      'amount': amount,
      'salesTohemId': salesTohemId,
      'remarks': remarks,
      'refpos3': refpos3,
      'tinv7': tinv7?.map((x) => x.toMap()).toList(),
      'tempItems': tempItems?.map((x) => x.toMap()).toList(),
      'isReceive': isReceive,
      'isSelected': isSelected,
    };
  }

  factory DownPaymentEntity.fromMap(Map<String, dynamic> map) {
    return DownPaymentEntity(
      refpos2: map['refpos2'] != null ? map['refpos2'] as String : null,
      toinvDocId: map['toinvDocId'] != null ? map['toinvDocId'] as String : null,
      amount: map['amount'] as double,
      salesTohemId: map['salesTohemId'] != null ? map['salesTohemId'] as String : null,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      refpos3: map['refpos3'] != null ? map['refpos3'] as String : null,
      tinv7: map['tinv7'] != null
          ? List<DownPaymentItemsEntity>.from(
              (map['tinv7'] as List<dynamic>).map<DownPaymentItemsEntity?>(
                (x) => DownPaymentItemsEntity.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      tempItems: map['tempItems'] != null
          ? List<ItemEntity>.from(
              (map['tempItems'] as List<dynamic>).map<ItemEntity?>(
                (x) => ItemEntity.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      isReceive: map['isReceive'] != null ? map['isReceive'] as bool : false,
      isSelected: map['isSelected'] != null ? map['isSelected'] as bool : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory DownPaymentEntity.fromJson(String source) =>
      DownPaymentEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DownPaymentEntity(refpos2: $refpos2, toinvDocId: $toinvDocId, amount: $amount, tinv7: $tinv7, tempItems: $tempItems, isReceive: $isReceive, isSelected: $isSelected), refpos3: $refpos3, salesTohemId: $salesTohemId, remarks: $remarks';
  }

  @override
  bool operator ==(covariant DownPaymentEntity other) {
    if (identical(this, other)) return true;

    return other.refpos2 == refpos2 &&
        other.toinvDocId == toinvDocId &&
        other.amount == amount &&
        other.salesTohemId == salesTohemId &&
        other.remarks == remarks &&
        other.refpos3 == refpos3 &&
        listEquals(other.tinv7, tinv7) &&
        listEquals(other.tempItems, tempItems) &&
        other.isReceive == isReceive &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    return refpos2.hashCode ^
        toinvDocId.hashCode ^
        amount.hashCode ^
        salesTohemId.hashCode ^
        remarks.hashCode ^
        refpos3.hashCode ^
        tinv7.hashCode ^
        tempItems.hashCode ^
        isReceive.hashCode ^
        isSelected.hashCode;
  }
}
