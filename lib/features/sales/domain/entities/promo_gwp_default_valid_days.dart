// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoGWPDefaultValidDaysEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String toprgId;
  final int day;
  final int status;

  PromoGWPDefaultValidDaysEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprgId,
    required this.day,
    required this.status,
  });

  PromoGWPDefaultValidDaysEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprgId,
    int? day,
    int? status,
  }) {
    return PromoGWPDefaultValidDaysEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprgId: toprgId ?? this.toprgId,
      day: day ?? this.day,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprgId': toprgId,
      'day': day,
      'status': status,
    };
  }

  factory PromoGWPDefaultValidDaysEntity.fromMap(Map<String, dynamic> map) {
    return PromoGWPDefaultValidDaysEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprgId: map['toprgId'] as String,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoGWPDefaultValidDaysEntity.fromJson(String source) =>
      PromoGWPDefaultValidDaysEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoGWPDefaultValidDaysEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprgId: $toprgId, day: $day, status: $status)';
  }

  @override
  bool operator ==(covariant PromoGWPDefaultValidDaysEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprgId == toprgId &&
        other.day == day &&
        other.status == status;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprgId.hashCode ^
        day.hashCode ^
        status.hashCode;
  }
}
