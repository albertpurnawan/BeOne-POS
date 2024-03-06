// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoCouponValidDaysEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tprn2Id;
  final int day;
  final int status;

  PromoCouponValidDaysEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tprn2Id,
    required this.day,
    required this.status,
  });

  PromoCouponValidDaysEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tprn2Id,
    int? day,
    int? status,
  }) {
    return PromoCouponValidDaysEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tprn2Id: tprn2Id ?? this.tprn2Id,
      day: day ?? this.day,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tprn2Id': tprn2Id,
      'day': day,
      'status': status,
    };
  }

  factory PromoCouponValidDaysEntity.fromMap(Map<String, dynamic> map) {
    return PromoCouponValidDaysEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tprn2Id: map['tprn2Id'] != null ? map['tprn2Id'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoCouponValidDaysEntity.fromJson(String source) =>
      PromoCouponValidDaysEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoCouponValidDaysEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tprn2Id: $tprn2Id, day: $day, status: $status)';
  }

  @override
  bool operator ==(covariant PromoCouponValidDaysEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tprn2Id == tprn2Id &&
        other.day == day &&
        other.status == status;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tprn2Id.hashCode ^
        day.hashCode ^
        status.hashCode;
  }
}
