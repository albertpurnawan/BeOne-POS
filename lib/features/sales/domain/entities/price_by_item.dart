// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PriceByItemEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tpln1Id;
  final String? toitmId;
  final String? tcurrId;
  final double price;
  // final double? purchasePrice;
  // final double? calculatedPrice;
  // final double? marginPercentage;
  // final double? marginValue;
  // final double? costPrice;
  // final double? afterRounding;
  // final double? beforeRounding;
  // final double? roundingDiff;

  PriceByItemEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tpln1Id,
    required this.toitmId,
    required this.tcurrId,
    required this.price,
    // required this.purchasePrice,
    // required this.calculatedPrice,
    // required this.marginPercentage,
    // required this.marginValue,
    // required this.costPrice,
    // required this.afterRounding,
    // required this.beforeRounding,
    // required this.roundingDiff,
  });

  PriceByItemEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tpln1Id,
    String? toitmId,
    String? tcurrId,
    double? price,
    // double? purchasePrice,
    // double? calculatedPrice,
    // double? marginPercentage,
    // double? marginValue,
    // double? costPrice,
    // double? afterRounding,
    // double? beforeRounding,
    // double? roundingDiff,
  }) {
    return PriceByItemEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tpln1Id: tpln1Id ?? this.tpln1Id,
      toitmId: toitmId ?? this.toitmId,
      tcurrId: tcurrId ?? this.tcurrId,
      price: price ?? this.price,
      // purchasePrice: purchasePrice ?? this.purchasePrice,
      // calculatedPrice: calculatedPrice ?? this.calculatedPrice,
      // marginPercentage: marginPercentage ?? this.marginPercentage,
      // marginValue: marginValue ?? this.marginValue,
      // costPrice: costPrice ?? this.costPrice,
      // afterRounding: afterRounding ?? this.afterRounding,
      // beforeRounding: beforeRounding ?? this.beforeRounding,
      // roundingDiff: roundingDiff ?? this.roundingDiff,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tpln1Id': tpln1Id,
      'toitmId': toitmId,
      'tcurrId': tcurrId,
      'price': price,
      // 'purchasePrice': purchasePrice,
      // 'calculatedPrice': calculatedPrice,
      // 'marginPercentage': marginPercentage,
      // 'marginValue': marginValue,
      // 'costPrice': costPrice,
      // 'afterRounding': afterRounding,
      // 'beforeRounding': beforeRounding,
      // 'roundingDiff': roundingDiff,
    };
  }

  factory PriceByItemEntity.fromMap(Map<String, dynamic> map) {
    return PriceByItemEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tpln1Id: map['tpln1Id'] != null ? map['tpln1Id'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
      price: map['price'] as double,
      // purchasePrice:
      //     map['purchasePrice'] != null ? map['purchasePrice'] as double : null,
      // calculatedPrice: map['calculatedPrice'] != null
      //     ? map['calculatedPrice'] as double
      //     : null,
      // marginPercentage: map['marginPercentage'] != null
      //     ? map['marginPercentage'] as double
      //     : null,
      // marginValue:
      //     map['marginValue'] != null ? map['marginValue'] as double : null,
      // costPrice: map['costPrice'] != null ? map['costPrice'] as double : null,
      // afterRounding:
      //     map['afterRounding'] != null ? map['afterRounding'] as double : null,
      // beforeRounding: map['beforeRounding'] != null
      //     ? map['beforeRounding'] as double
      //     : null,
      // roundingDiff:
      //     map['roundingDiff'] != null ? map['roundingDiff'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PriceByItemEntity.fromJson(String source) =>
      PriceByItemEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PriceByItemEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tpln1Id: $tpln1Id, toitmId: $toitmId, tcurrId: $tcurrId, price: $price, )'; //purchasePrice: $purchasePrice, calculatedPrice: $calculatedPrice, marginPercentage: $marginPercentage, marginValue: $marginValue, costPrice: $costPrice, afterRounding: $afterRounding, beforeRounding: $beforeRounding, roundingDiff: $roundingDiff
  }

  @override
  bool operator ==(covariant PriceByItemEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tpln1Id == tpln1Id &&
        other.toitmId == toitmId &&
        other.tcurrId == tcurrId &&
        other.price == price;
    // other.purchasePrice == purchasePrice &&
    // other.calculatedPrice == calculatedPrice &&
    // other.marginPercentage == marginPercentage &&
    // other.marginValue == marginValue &&
    // other.costPrice == costPrice &&
    // other.afterRounding == afterRounding &&
    // other.beforeRounding == beforeRounding &&
    // other.roundingDiff == roundingDiff;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tpln1Id.hashCode ^
        toitmId.hashCode ^
        tcurrId.hashCode ^
        price.hashCode;
    // purchasePrice.hashCode ^
    // calculatedPrice.hashCode ^
    // marginPercentage.hashCode ^
    // marginValue.hashCode ^
    // costPrice.hashCode ^
    // afterRounding.hashCode ^
    // beforeRounding.hashCode ^
    // roundingDiff.hashCode;
  }
}
