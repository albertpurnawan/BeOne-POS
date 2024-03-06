// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoVoucherHeaderEntity {
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
  final int validDays;
  final double minPurchase;
  final double minNextPurchase;
  final int minNextPurchasex;
  final String voucherType;
  final double voucherValue;
  final double voucherPct;
  final int statusActive;

  PromoVoucherHeaderEntity({
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
    required this.validDays,
    required this.minPurchase,
    required this.minNextPurchase,
    required this.minNextPurchasex,
    required this.voucherType,
    required this.voucherValue,
    required this.voucherPct,
    required this.statusActive,
  });

  PromoVoucherHeaderEntity copyWith({
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
    int? validDays,
    double? minPurchase,
    double? minNextPurchase,
    int? minNextPurchasex,
    String? voucherType,
    double? voucherValue,
    double? voucherPct,
    int? statusActive,
  }) {
    return PromoVoucherHeaderEntity(
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
      validDays: validDays ?? this.validDays,
      minPurchase: minPurchase ?? this.minPurchase,
      minNextPurchase: minNextPurchase ?? this.minNextPurchase,
      minNextPurchasex: minNextPurchasex ?? this.minNextPurchasex,
      voucherType: voucherType ?? this.voucherType,
      voucherValue: voucherValue ?? this.voucherValue,
      voucherPct: voucherPct ?? this.voucherPct,
      statusActive: statusActive ?? this.statusActive,
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
      'validDays': validDays,
      'minPurchase': minPurchase,
      'minNextPurchase': minNextPurchase,
      'minNextPurchasex': minNextPurchasex,
      'voucherType': voucherType,
      'voucherValue': voucherValue,
      'voucherPct': voucherPct,
      'statusActive': statusActive,
    };
  }

  factory PromoVoucherHeaderEntity.fromMap(Map<String, dynamic> map) {
    return PromoVoucherHeaderEntity(
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
      validDays: map['validDays'] as int,
      minPurchase: map['minPurchase'] as double,
      minNextPurchase: map['minNextPurchase'] as double,
      minNextPurchasex: map['minNextPurchasex'] as int,
      voucherType: map['voucherType'] as String,
      voucherValue: map['voucherValue'] as double,
      voucherPct: map['voucherPct'] as double,
      statusActive: map['statusActive'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoVoucherHeaderEntity.fromJson(String source) =>
      PromoVoucherHeaderEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoVoucherHeaderEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, promoCode: $promoCode, description: $description, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, remarks: $remarks, validDays: $validDays, minPurchase: $minPurchase, minNextPurchase: $minNextPurchase, voucherType: $voucherType, voucherValue: $voucherValue, voucherPct: $voucherPct, statusActive: $statusActive)';
  }

  @override
  bool operator ==(covariant PromoVoucherHeaderEntity other) {
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
        other.validDays == validDays &&
        other.minPurchase == minPurchase &&
        other.minNextPurchase == minNextPurchase &&
        other.minNextPurchasex == minNextPurchasex &&
        other.voucherType == voucherType &&
        other.voucherValue == voucherValue &&
        other.voucherPct == voucherPct &&
        other.statusActive == statusActive;
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
        validDays.hashCode ^
        minPurchase.hashCode ^
        minNextPurchase.hashCode ^
        minNextPurchasex.hashCode ^
        voucherType.hashCode ^
        voucherValue.hashCode ^
        voucherPct.hashCode ^
        statusActive.hashCode;
  }
}
