// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StartShiftEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String tocsrId;
  final String tohemId; //startedBy
  final DateTime startDate;
  final DateTime startTime;
  final String timezone;
  final double startingCash;

  StartShiftEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tocsrId,
    required this.tohemId,
    required this.startDate,
    required this.startTime,
    required this.timezone,
    required this.startingCash,
  });

  StartShiftEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tocsrId,
    String? tohemId,
    DateTime? startDate,
    DateTime? startTime,
    String? timezone,
    double? startingCash,
  }) {
    return StartShiftEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tocsrId: tocsrId ?? this.tocsrId,
      tohemId: tohemId ?? this.tohemId,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      timezone: timezone ?? this.timezone,
      startingCash: startingCash ?? this.startingCash,
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
    };
  }

  factory StartShiftEntity.fromMap(Map<String, dynamic> map) {
    return StartShiftEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tocsrId: map['tocsrId'] as String,
      tohemId: map['tohemId'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      timezone: map['timezone'] as String,
      startingCash: map['startingCash'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory StartShiftEntity.fromJson(String source) =>
      StartShiftEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StartShiftEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tocsrId: $tocsrId, tohemId: $tohemId, startDate: $startDate, startTime: $startTime, timezone: $timezone, startingCash: $startingCash)';
  }

  @override
  bool operator ==(covariant StartShiftEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tocsrId == tocsrId &&
        other.tohemId == tohemId &&
        other.startDate == startDate &&
        other.startTime == startTime &&
        other.timezone == timezone &&
        other.startingCash == startingCash;
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
        startingCash.hashCode;
  }
}
