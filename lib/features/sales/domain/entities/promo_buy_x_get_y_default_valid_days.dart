// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoBuyXGetYDefaultValidDaysEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprbId;
  final int day;
  final int status;

  PromoBuyXGetYDefaultValidDaysEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprbId,
    required this.day,
    required this.status,
  });

  PromoBuyXGetYDefaultValidDaysEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprbId,
    int? day,
    int? status,
  }) {
    return PromoBuyXGetYDefaultValidDaysEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprbId: toprbId ?? this.toprbId,
      day: day ?? this.day,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprbId': toprbId,
      'day': day,
      'status': status,
    };
  }

  factory PromoBuyXGetYDefaultValidDaysEntity.fromMap(
      Map<String, dynamic> map) {
    return PromoBuyXGetYDefaultValidDaysEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprbId: map['toprbId'] != null ? map['toprbId'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBuyXGetYDefaultValidDaysEntity.fromJson(String source) =>
      PromoBuyXGetYDefaultValidDaysEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBuyXGetYDefaultValidDaysEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprbId: $toprbId, day: $day, status: $status)';
  }

  @override
  bool operator ==(covariant PromoBuyXGetYDefaultValidDaysEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprbId == toprbId &&
        other.day == day &&
        other.status == status;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprbId.hashCode ^
        day.hashCode ^
        status.hashCode;
  }
}
