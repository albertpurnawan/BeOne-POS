// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoCouponDefaultValidDaysEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprnId;
  final int day;
  final int status;

  PromoCouponDefaultValidDaysEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprnId,
    required this.day,
    required this.status,
  });

  PromoCouponDefaultValidDaysEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprnId,
    int? day,
    int? status,
  }) {
    return PromoCouponDefaultValidDaysEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprnId: toprnId ?? this.toprnId,
      day: day ?? this.day,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprnId': toprnId,
      'day': day,
      'status': status,
    };
  }

  factory PromoCouponDefaultValidDaysEntity.fromMap(Map<String, dynamic> map) {
    return PromoCouponDefaultValidDaysEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprnId: map['toprnId'] != null ? map['toprnId'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoCouponDefaultValidDaysEntity.fromJson(String source) =>
      PromoCouponDefaultValidDaysEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoCouponDefaultValidDaysEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprnId: $toprnId, day: $day, status: $status)';
  }

  @override
  bool operator ==(covariant PromoCouponDefaultValidDaysEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprnId == toprnId &&
        other.day == day &&
        other.status == status;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprnId.hashCode ^
        day.hashCode ^
        status.hashCode;
  }
}
