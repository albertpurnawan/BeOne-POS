// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoGWPValidDaysEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tprg2Id;
  final int day;
  final int status;

  PromoGWPValidDaysEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tprg2Id,
    required this.day,
    required this.status,
  });

  PromoGWPValidDaysEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tprg2Id,
    int? day,
    int? status,
  }) {
    return PromoGWPValidDaysEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tprg2Id: tprg2Id ?? this.tprg2Id,
      day: day ?? this.day,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tprg2Id': tprg2Id,
      'day': day,
      'status': status,
    };
  }

  factory PromoGWPValidDaysEntity.fromMap(Map<String, dynamic> map) {
    return PromoGWPValidDaysEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tprg2Id: map['tprg2Id'] != null ? map['tprg2Id'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoGWPValidDaysEntity.fromJson(String source) =>
      PromoGWPValidDaysEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoGWPValidDaysEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tprg2Id: $tprg2Id, day: $day, status: $status)';
  }

  @override
  bool operator ==(covariant PromoGWPValidDaysEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tprg2Id == tprg2Id &&
        other.day == day &&
        other.status == status;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tprg2Id.hashCode ^
        day.hashCode ^
        status.hashCode;
  }
}
