// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoGWPHeaderEntity {
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
  final int priority;
  final int priorityNo;
  final double minPurchase;
  final double maxGet;
  final String getCondition;
  final int statusActive;

  PromoGWPHeaderEntity({
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
    required this.priority,
    required this.priorityNo,
    required this.minPurchase,
    required this.maxGet,
    required this.getCondition,
    required this.statusActive,
  });

  PromoGWPHeaderEntity copyWith({
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
    int? priority,
    int? priorityNo,
    double? minPurchase,
    double? maxGet,
    String? getCondition,
    int? statusActive,
  }) {
    return PromoGWPHeaderEntity(
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
      priority: priority ?? this.priority,
      priorityNo: priorityNo ?? this.priorityNo,
      minPurchase: minPurchase ?? this.minPurchase,
      maxGet: maxGet ?? this.maxGet,
      getCondition: getCondition ?? this.getCondition,
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
      'priority': priority,
      'priorityNo': priorityNo,
      'minPurchase': minPurchase,
      'maxGet': maxGet,
      'getCondition': getCondition,
      'statusActive': statusActive,
    };
  }

  factory PromoGWPHeaderEntity.fromMap(Map<String, dynamic> map) {
    return PromoGWPHeaderEntity(
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
      priority: map['priority'] as int,
      priorityNo: map['priorityNo'] as int,
      minPurchase: map['minPurchase'] as double,
      maxGet: map['maxGet'] as double,
      getCondition: map['getCondition'] as String,
      statusActive: map['statusActive'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoGWPHeaderEntity.fromJson(String source) =>
      PromoGWPHeaderEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoGWPHeaderEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, promoCode: $promoCode, description: $description, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, remarks: $remarks, priority: $priority, priorityNo: $priorityNo, minPurchase: $minPurchase, maxGet: $maxGet, getCondition: $getCondition, statusActive: $statusActive)';
  }

  @override
  bool operator ==(covariant PromoGWPHeaderEntity other) {
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
        other.priority == priority &&
        other.priorityNo == priorityNo &&
        other.minPurchase == minPurchase &&
        other.maxGet == maxGet &&
        other.getCondition == getCondition &&
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
        priority.hashCode ^
        priorityNo.hashCode ^
        minPurchase.hashCode ^
        maxGet.hashCode ^
        getCondition.hashCode ^
        statusActive.hashCode;
  }
}
