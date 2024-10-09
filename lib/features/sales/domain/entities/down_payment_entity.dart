// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pos_fe/features/sales/data/models/down_payment_items_model.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';

class DownPaymentEntity {
  final String? refpos2;
  final String? toinvDocId;
  final double amount;
  final List<DownPaymentItemsModel>? tinv7;
  final List<ItemEntity>? tempItems;
  final bool? isReceive;

  DownPaymentEntity({
    this.refpos2,
    this.toinvDocId,
    required this.amount,
    this.tinv7,
    this.tempItems,
    this.isReceive,
  });

  DownPaymentEntity copyWith({
    String? refpos2,
    String? toinvDocId,
    double? amount,
    List<DownPaymentItemsModel>? tinv7,
    List<ItemEntity>? tempItems,
    bool? isReceive,
  }) {
    return DownPaymentEntity(
      refpos2: refpos2 ?? this.refpos2,
      toinvDocId: toinvDocId ?? this.toinvDocId,
      amount: amount ?? this.amount,
      tinv7: tinv7 ?? this.tinv7,
      tempItems: tempItems ?? this.tempItems,
      isReceive: isReceive ?? this.isReceive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'refpos2': refpos2,
      'toinvDocId': toinvDocId,
      'amount': amount,
      'tinv7': tinv7?.map((x) => x.toMap()).toList(),
      'tempItems': tempItems?.map((x) => x.toMap()).toList(),
      'isReceive': isReceive,
    };
  }

  factory DownPaymentEntity.fromMap(Map<String, dynamic> map) {
    return DownPaymentEntity(
      refpos2: map['refpos2'] != null ? map['refpos2'] as String : null,
      toinvDocId: map['toinvDocId'] != null ? map['toinvDocId'] as String : null,
      amount: map['amount'] as double,
      tinv7: map['tinv7'] != null
          ? List<DownPaymentItemsModel>.from(
              (map['tinv7'] as List<dynamic>).map<DownPaymentItemsModel?>(
                (x) => DownPaymentItemsModel.fromMap(x as Map<String, dynamic>),
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
    );
  }

  String toJson() => json.encode(toMap());

  factory DownPaymentEntity.fromJson(String source) =>
      DownPaymentEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DownPaymentEntity(refpos2: $refpos2, toinvDocId: $toinvDocId, amount: $amount, tinv7: $tinv7, tempItems: $tempItems, isReceive: $isReceive)';
  }

  @override
  bool operator ==(covariant DownPaymentEntity other) {
    if (identical(this, other)) return true;

    return other.refpos2 == refpos2 &&
        other.toinvDocId == toinvDocId &&
        other.amount == amount &&
        listEquals(other.tinv7, tinv7) &&
        listEquals(other.tempItems, tempItems) &&
        other.isReceive == isReceive;
  }

  @override
  int get hashCode {
    return refpos2.hashCode ^
        toinvDocId.hashCode ^
        amount.hashCode ^
        tinv7.hashCode ^
        tempItems.hashCode ^
        isReceive.hashCode;
  }
}
