// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoVoucherDefaultValidDaysEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprrId;
  final int day;
  final int status;

  PromoVoucherDefaultValidDaysEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprrId,
    required this.day,
    required this.status,
  });

  PromoVoucherDefaultValidDaysEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprrId,
    int? day,
    int? status,
  }) {
    return PromoVoucherDefaultValidDaysEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprrId: toprrId ?? this.toprrId,
      day: day ?? this.day,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprrId': toprrId,
      'day': day,
      'status': status,
    };
  }

  factory PromoVoucherDefaultValidDaysEntity.fromMap(Map<String, dynamic> map) {
    return PromoVoucherDefaultValidDaysEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprrId: map['toprrId'] != null ? map['toprrId'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoVoucherDefaultValidDaysEntity.fromJson(String source) =>
      PromoVoucherDefaultValidDaysEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoVoucherDefaultValidDaysEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprrId: $toprrId, day: $day, status: $status)';
  }

  @override
  bool operator ==(covariant PromoVoucherDefaultValidDaysEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprrId == toprrId &&
        other.day == day &&
        other.status == status;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprrId.hashCode ^
        day.hashCode ^
        status.hashCode;
  }
}
