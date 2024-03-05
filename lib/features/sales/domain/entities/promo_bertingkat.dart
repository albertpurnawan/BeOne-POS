// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoBertingkatEntity {
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
  final String? toplnId;

  PromoBertingkatEntity({
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
    required this.toplnId,
  });

  PromoBertingkatEntity copyWith({
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
    String? toplnId,
  }) {
    return PromoBertingkatEntity(
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
      toplnId: toplnId ?? this.toplnId,
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
      'toplnId': toplnId,
    };
  }

  factory PromoBertingkatEntity.fromMap(Map<String, dynamic> map) {
    return PromoBertingkatEntity(
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
      toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBertingkatEntity.fromJson(String source) =>
      PromoBertingkatEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBertingkatEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, promoCode: $promoCode, description: $description, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, remarks: $remarks, statusActive: $statusActive, toplnId: $toplnId)';
  }

  @override
  bool operator ==(covariant PromoBertingkatEntity other) {
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
        other.toplnId == toplnId;
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
        toplnId.hashCode;
  }
}
