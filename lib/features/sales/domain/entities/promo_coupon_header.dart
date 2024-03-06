// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoCouponHeaderEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String couponCode;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime startTime;
  final DateTime endTime;
  final String? remarks;
  final int includePromo;
  final int maxTimes;
  final double minPurchase;
  final double generalDisc;
  final String maxGeneralDisc;
  final double memberDisc;
  final double maxMemberDisc;
  final int statusActive;

  PromoCouponHeaderEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.couponCode,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.remarks,
    required this.includePromo,
    required this.maxTimes,
    required this.minPurchase,
    required this.generalDisc,
    required this.maxGeneralDisc,
    required this.memberDisc,
    required this.maxMemberDisc,
    required this.statusActive,
  });

  PromoCouponHeaderEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? couponCode,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? startTime,
    DateTime? endTime,
    String? remarks,
    int? includePromo,
    int? maxTimes,
    double? minPurchase,
    double? generalDisc,
    String? maxGeneralDisc,
    double? memberDisc,
    double? maxMemberDisc,
    int? statusActive,
  }) {
    return PromoCouponHeaderEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      couponCode: couponCode ?? this.couponCode,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      remarks: remarks ?? this.remarks,
      includePromo: includePromo ?? this.includePromo,
      maxTimes: maxTimes ?? this.maxTimes,
      minPurchase: minPurchase ?? this.minPurchase,
      generalDisc: generalDisc ?? this.generalDisc,
      maxGeneralDisc: maxGeneralDisc ?? this.maxGeneralDisc,
      memberDisc: memberDisc ?? this.memberDisc,
      maxMemberDisc: maxMemberDisc ?? this.maxMemberDisc,
      statusActive: statusActive ?? this.statusActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'couponCode': couponCode,
      'description': description,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'remarks': remarks,
      'includePromo': includePromo,
      'maxTimes': maxTimes,
      'minPurchase': minPurchase,
      'generalDisc': generalDisc,
      'maxGeneralDisc': maxGeneralDisc,
      'memberDisc': memberDisc,
      'maxMemberDisc': maxMemberDisc,
      'statusActive': statusActive,
    };
  }

  factory PromoCouponHeaderEntity.fromMap(Map<String, dynamic> map) {
    return PromoCouponHeaderEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      couponCode: map['couponCode'] as String,
      description: map['description'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int),
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      includePromo: map['includePromo'] as int,
      maxTimes: map['maxTimes'] as int,
      minPurchase: map['minPurchase'] as double,
      generalDisc: map['generalDisc'] as double,
      maxGeneralDisc: map['maxGeneralDisc'] as String,
      memberDisc: map['memberDisc'] as double,
      maxMemberDisc: map['maxMemberDisc'] as double,
      statusActive: map['statusActive'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoCouponHeaderEntity.fromJson(String source) =>
      PromoCouponHeaderEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoCouponHeaderEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, couponCode: $couponCode, description: $description, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, remarks: $remarks, includePromo: $includePromo, maxTimes: $maxTimes, minPurchase: $minPurchase, generalDisc: $generalDisc, maxGeneralDisc: $maxGeneralDisc, memberDisc: $memberDisc, maxMemberDisc: $maxMemberDisc, statusActive: $statusActive)';
  }

  @override
  bool operator ==(covariant PromoCouponHeaderEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.couponCode == couponCode &&
        other.description == description &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.remarks == remarks &&
        other.includePromo == includePromo &&
        other.maxTimes == maxTimes &&
        other.minPurchase == minPurchase &&
        other.generalDisc == generalDisc &&
        other.maxGeneralDisc == maxGeneralDisc &&
        other.memberDisc == memberDisc &&
        other.maxMemberDisc == maxMemberDisc &&
        other.statusActive == statusActive;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        couponCode.hashCode ^
        description.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        remarks.hashCode ^
        includePromo.hashCode ^
        maxTimes.hashCode ^
        minPurchase.hashCode ^
        generalDisc.hashCode ^
        maxGeneralDisc.hashCode ^
        memberDisc.hashCode ^
        maxMemberDisc.hashCode ^
        statusActive.hashCode;
  }
}
