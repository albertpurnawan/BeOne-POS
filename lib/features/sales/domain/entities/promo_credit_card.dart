// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoCreditCardEntity {
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
  final double minPurchase;
  final double discPct;
  final double discValue;
  final int statusActive;

  PromoCreditCardEntity({
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
    required this.minPurchase,
    required this.discPct,
    required this.discValue,
    required this.statusActive,
  });

  PromoCreditCardEntity copyWith({
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
    double? minPurchase,
    double? discPct,
    double? discValue,
    int? statusActive,
  }) {
    return PromoCreditCardEntity(
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
      minPurchase: minPurchase ?? this.minPurchase,
      discPct: discPct ?? this.discPct,
      discValue: discValue ?? this.discValue,
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
      'minPurchase': minPurchase,
      'discPct': discPct,
      'discValue': discValue,
      'statusActive': statusActive,
    };
  }

  factory PromoCreditCardEntity.fromMap(Map<String, dynamic> map) {
    return PromoCreditCardEntity(
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
      minPurchase: map['minPurchase'] as double,
      discPct: map['discPct'] as double,
      discValue: map['discValue'] as double,
      statusActive: map['statusActive'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoCreditCardEntity.fromJson(String source) =>
      PromoCreditCardEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoCreditCardEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, promoCode: $promoCode, description: $description, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, remarks: $remarks, minPurchase: $minPurchase, discPct: $discPct, discValue: $discValue, statusActive: $statusActive)';
  }

  @override
  bool operator ==(covariant PromoCreditCardEntity other) {
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
        other.minPurchase == minPurchase &&
        other.discPct == discPct &&
        other.discValue == discValue &&
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
        minPurchase.hashCode ^
        discPct.hashCode ^
        discValue.hashCode ^
        statusActive.hashCode;
  }
}
