// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoDiskonItemHeaderEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String promoCode;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime startTime;
  final DateTime endTime;
  final String? remarks;
  final int statusActive;
  final int promoType;
  final int buyCondition;
  final double promoValue;
  final double discount1;
  final double discount2;
  final double discount3;
  final double? totalQtyFrom;
  final double? totalQtyTo;
  final double? totalPriceFrom;
  final double? totalPriceTo;

  PromoDiskonItemHeaderEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.promoCode,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.remarks,
    required this.statusActive,
    required this.promoType,
    required this.buyCondition,
    required this.promoValue,
    required this.discount1,
    required this.discount2,
    required this.discount3,
    required this.totalQtyFrom,
    required this.totalQtyTo,
    required this.totalPriceFrom,
    required this.totalPriceTo,
  });

  PromoDiskonItemHeaderEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? promoCode,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? startTime,
    DateTime? endTime,
    String? remarks,
    int? statusActive,
    int? promoType,
    int? buyCondition,
    double? promoValue,
    double? discount1,
    double? discount2,
    double? discount3,
    double? totalQtyFrom,
    double? totalQtyTo,
    double? totalPriceFrom,
    double? totalPriceTo,
  }) {
    return PromoDiskonItemHeaderEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      promoCode: promoCode ?? this.promoCode,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      remarks: remarks ?? this.remarks,
      statusActive: statusActive ?? this.statusActive,
      promoType: promoType ?? this.promoType,
      buyCondition: buyCondition ?? this.buyCondition,
      promoValue: promoValue ?? this.promoValue,
      discount1: discount1 ?? this.discount1,
      discount2: discount2 ?? this.discount2,
      discount3: discount3 ?? this.discount3,
      totalQtyFrom: totalQtyFrom ?? this.totalQtyFrom,
      totalQtyTo: totalQtyTo ?? this.totalQtyTo,
      totalPriceFrom: totalPriceFrom ?? this.totalPriceFrom,
      totalPriceTo: totalPriceTo ?? this.totalPriceTo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'promoCode': promoCode,
      'description': description,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'remarks': remarks,
      'statusActive': statusActive,
      'promoType': promoType,
      'buyCondition': buyCondition,
      'promoValue': promoValue,
      'discount1': discount1,
      'discount2': discount2,
      'discount3': discount3,
      'totalQtyFrom': totalQtyFrom,
      'totalQtyTo': totalQtyTo,
      'totalPriceFrom': totalPriceFrom,
      'totalPriceTo': totalPriceTo,
    };
  }

  factory PromoDiskonItemHeaderEntity.fromMap(Map<String, dynamic> map) {
    return PromoDiskonItemHeaderEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      promoCode: map['promoCode'] as String,
      description: map['description'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int),
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      statusActive: map['statusActive'] as int,
      promoType: map['promoType'] as int,
      buyCondition: map['buyCondition'] as int,
      promoValue: map['promoValue'] as double,
      discount1: map['discount1'] as double,
      discount2: map['discount2'] as double,
      discount3: map['discount3'] as double,
      totalQtyFrom:
          map['totalQtyFrom'] != null ? map['totalQtyFrom'] as double : null,
      totalQtyTo:
          map['totalQtyTo'] != null ? map['totalQtyTo'] as double : null,
      totalPriceFrom: map['totalPriceFrom'] != null
          ? map['totalPriceFrom'] as double
          : null,
      totalPriceTo:
          map['totalPriceTo'] != null ? map['totalPriceTo'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoDiskonItemHeaderEntity.fromJson(String source) =>
      PromoDiskonItemHeaderEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoDiskonItemHeaderEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, promoCode: $promoCode, description: $description, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, remarks: $remarks, statusActive: $statusActive, promoType: $promoType, buyCondition: $buyCondition, promoValue: $promoValue, discount1: $discount1, discount2: $discount2, discount3: $discount3, totalQtyFrom: $totalQtyFrom, totalQtyTo: $totalQtyTo, totalPriceFrom: $totalPriceFrom, totalPriceTo: $totalPriceTo)';
  }

  @override
  bool operator ==(covariant PromoDiskonItemHeaderEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.promoCode == promoCode &&
        other.description == description &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.remarks == remarks &&
        other.statusActive == statusActive &&
        other.promoType == promoType &&
        other.buyCondition == buyCondition &&
        other.promoValue == promoValue &&
        other.discount1 == discount1 &&
        other.discount2 == discount2 &&
        other.discount3 == discount3 &&
        other.totalQtyFrom == totalQtyFrom &&
        other.totalQtyTo == totalQtyTo &&
        other.totalPriceFrom == totalPriceFrom &&
        other.totalPriceTo == totalPriceTo;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        promoCode.hashCode ^
        description.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        remarks.hashCode ^
        statusActive.hashCode ^
        promoType.hashCode ^
        buyCondition.hashCode ^
        promoValue.hashCode ^
        discount1.hashCode ^
        discount2.hashCode ^
        discount3.hashCode ^
        totalQtyFrom.hashCode ^
        totalQtyTo.hashCode ^
        totalPriceFrom.hashCode ^
        totalPriceTo.hashCode;
  }
}
