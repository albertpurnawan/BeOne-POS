import 'dart:convert';

class MOPAdjustmentHeaderEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String docNum;
  final DateTime docDate;
  final DateTime docTime;
  final String timezone;
  final int posted;
  final DateTime postDate;
  final DateTime postTime;
  final String? remarks;
  final String? tostrId;
  final int sync;

  MOPAdjustmentHeaderEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.docNum,
    required this.docDate,
    required this.docTime,
    required this.timezone,
    required this.posted,
    required this.postDate,
    required this.postTime,
    required this.remarks,
    required this.tostrId,
    required this.sync,
  });

  MOPAdjustmentHeaderEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? docNum,
    DateTime? docDate,
    DateTime? docTime,
    String? timezone,
    int? posted,
    DateTime? postDate,
    DateTime? postTime,
    String? remarks,
    String? tostrId,
    int? sync,
  }) {
    return MOPAdjustmentHeaderEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      docNum: docNum ?? this.docNum,
      docDate: docDate ?? this.docDate,
      docTime: docTime ?? this.docTime,
      timezone: timezone ?? this.timezone,
      posted: posted ?? this.posted,
      postDate: postDate ?? this.postDate,
      postTime: postTime ?? this.postTime,
      remarks: remarks ?? this.remarks,
      tostrId: tostrId ?? this.tostrId,
      sync: sync ?? this.sync,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'docNum': docNum,
      'docDate': docDate.millisecondsSinceEpoch,
      'docTime': docTime.millisecondsSinceEpoch,
      'timezone': timezone,
      'posted': posted,
      'postDate': postDate.millisecondsSinceEpoch,
      'postTime': postTime.millisecondsSinceEpoch,
      'remarks': remarks,
      'tostrId': tostrId,
      'sync': sync,
    };
  }

  factory MOPAdjustmentHeaderEntity.fromMap(Map<String, dynamic> map) {
    return MOPAdjustmentHeaderEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      docNum: map['docNum'] as String,
      docDate: DateTime.fromMillisecondsSinceEpoch(map['docDate'] as int),
      docTime: DateTime.fromMillisecondsSinceEpoch(map['docTime'] as int),
      timezone: map['timezone'] as String,
      posted: map['posted'] as int,
      postDate: DateTime.fromMillisecondsSinceEpoch(map['postDate'] as int),
      postTime: DateTime.fromMillisecondsSinceEpoch(map['postTime'] as int),
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      sync: map['sync'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MOPAdjustmentHeaderEntity.fromJson(String source) =>
      MOPAdjustmentHeaderEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MOPAdjustmentHeaderEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, docNum: $docNum, docDate: $docDate, docTime: $docTime, timezone: $timezone, posted: $posted, postDate: $postDate, postTime: $postTime, remarks: $remarks, tostrId: $tostrId, sync: $sync)';
  }

  @override
  bool operator ==(covariant MOPAdjustmentHeaderEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.docNum == docNum &&
        other.docDate == docDate &&
        other.docTime == docTime &&
        other.timezone == timezone &&
        other.posted == posted &&
        other.postDate == postDate &&
        other.postTime == postTime &&
        other.remarks == remarks &&
        other.tostrId == tostrId &&
        other.sync == sync;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        docNum.hashCode ^
        docDate.hashCode ^
        docTime.hashCode ^
        timezone.hashCode ^
        posted.hashCode ^
        postDate.hashCode ^
        postTime.hashCode ^
        remarks.hashCode ^
        tostrId.hashCode ^
        sync.hashCode;
  }
}
