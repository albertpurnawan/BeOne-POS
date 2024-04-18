import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class OpenShiftEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tocsrId;
  final String? tohemId; //startedBy
  final DateTime startDate;
  final DateTime startTime;
  final String timezone; //DateTime.now().timeZoneOffset.inHours;
  final double startingCash;
  final String? approvedBy;

  OpenShiftEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.tocsrId,
    this.tohemId,
    required this.startDate,
    required this.startTime,
    required this.timezone,
    required this.startingCash,
    this.approvedBy,
  });

  OpenShiftEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tocsrId,
    String? tohemId,
    DateTime? startDate,
    DateTime? startTime,
    String? timezone,
    double? startingCash,
    String? approvedBy,
  }) {
    return OpenShiftEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tocsrId: tocsrId ?? this.tocsrId,
      tohemId: tohemId ?? this.tohemId,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      timezone: timezone ?? this.timezone,
      startingCash: startingCash ?? this.startingCash,
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
      'startDate': startDate.millisecondsSinceEpoch,
      'startTime': startTime.millisecondsSinceEpoch,
      'timezone': timezone,
      'startingCash': startingCash,
      'approvedBy': approvedBy,
    };
  }

  factory OpenShiftEntity.fromMap(Map<String, dynamic> map) {
    return OpenShiftEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tocsrId: map['tocsrId'] != null ? map['tocsrId'] as String : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      timezone: map['timezone'] as String,
      startingCash: map['startingCash'] as double,
      approvedBy:
          map['approvedBy'] != null ? map['approvedBy'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OpenShiftEntity.fromJson(String source) =>
      OpenShiftEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OpenShiftEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tocsrId: $tocsrId, tohemId: $tohemId, startDate: $startDate, startTime: $startTime, timezone: $timezone, startingCash: $startingCash, approvedBy: $approvedBy)';
  }

  @override
  bool operator ==(covariant OpenShiftEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tocsrId == tocsrId &&
        other.tohemId == tohemId &&
        other.startDate == startDate &&
        other.startTime == startTime &&
        other.timezone == timezone &&
        other.startingCash == startingCash &&
        other.approvedBy == approvedBy;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tocsrId.hashCode ^
        tohemId.hashCode ^
        startDate.hashCode ^
        startTime.hashCode ^
        timezone.hashCode ^
        startingCash.hashCode ^
        approvedBy.hashCode;
  }
}
