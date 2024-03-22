// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CloseShiftEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tocsrId;
  final String? tohemId;
  final DateTime closeDate;
  final DateTime closeTime;
  final String timezone;
  final double expectedCash;
  final double actualCash;
  final int approvalStatus;
  final String? approvedBy;

  CloseShiftEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tocsrId,
    required this.tohemId,
    required this.closeDate,
    required this.closeTime,
    required this.timezone,
    required this.expectedCash,
    required this.actualCash,
    required this.approvalStatus,
    required this.approvedBy,
  });

  CloseShiftEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tocsrId,
    String? tohemId,
    DateTime? closeDate,
    DateTime? closeTime,
    String? timezone,
    double? expectedCash,
    double? actualCash,
    int? approvalStatus,
    String? approvedBy,
  }) {
    return CloseShiftEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tocsrId: tocsrId ?? this.tocsrId,
      tohemId: tohemId ?? this.tohemId,
      closeDate: closeDate ?? this.closeDate,
      closeTime: closeTime ?? this.closeTime,
      timezone: timezone ?? this.timezone,
      expectedCash: expectedCash ?? this.expectedCash,
      actualCash: actualCash ?? this.actualCash,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      approvedBy: approvedBy ?? this.approvedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tocsrId': tocsrId,
      'tohemId': tohemId,
      'closeDate': closeDate.millisecondsSinceEpoch,
      'closeTime': closeTime.millisecondsSinceEpoch,
      'timezone': timezone,
      'expectedCash': expectedCash,
      'actualCash': actualCash,
      'approvalStatus': approvalStatus,
      'approvedBy': approvedBy,
    };
  }

  factory CloseShiftEntity.fromMap(Map<String, dynamic> map) {
    return CloseShiftEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tocsrId: map['tocsrId'] != null ? map['tocsrId'] as String : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      closeDate: DateTime.fromMillisecondsSinceEpoch(map['closeDate'] as int),
      closeTime: DateTime.fromMillisecondsSinceEpoch(map['closeTime'] as int),
      timezone: map['timezone'] as String,
      expectedCash: map['expectedCash'] as double,
      actualCash: map['actualCash'] as double,
      approvalStatus: map['approvalStatus'] as int,
      approvedBy:
          map['approvedBy'] != null ? map['approvedBy'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CloseShiftEntity.fromJson(String source) =>
      CloseShiftEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CloseShiftEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tocsrId: $tocsrId, tohemId: $tohemId, closeDate: $closeDate, closeTime: $closeTime, timezone: $timezone, expectedCash: $expectedCash, actualCash: $actualCash, approvalStatus: $approvalStatus, approvedBy: $approvedBy)';
  }

  @override
  bool operator ==(covariant CloseShiftEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tocsrId == tocsrId &&
        other.tohemId == tohemId &&
        other.closeDate == closeDate &&
        other.closeTime == closeTime &&
        other.timezone == timezone &&
        other.expectedCash == expectedCash &&
        other.actualCash == actualCash &&
        other.approvalStatus == approvalStatus &&
        other.approvedBy == approvedBy;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tocsrId.hashCode ^
        tohemId.hashCode ^
        closeDate.hashCode ^
        closeTime.hashCode ^
        timezone.hashCode ^
        expectedCash.hashCode ^
        actualCash.hashCode ^
        approvalStatus.hashCode ^
        approvedBy.hashCode;
  }
}
