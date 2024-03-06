// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoPackageValidDaysEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tprk2Id;
  final int day;
  final int status;

  PromoPackageValidDaysEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tprk2Id,
    required this.day,
    required this.status,
  });

  PromoPackageValidDaysEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tprk2Id,
    int? day,
    int? status,
  }) {
    return PromoPackageValidDaysEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tprk2Id: tprk2Id ?? this.tprk2Id,
      day: day ?? this.day,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tprk2Id': tprk2Id,
      'day': day,
      'status': status,
    };
  }

  factory PromoPackageValidDaysEntity.fromMap(Map<String, dynamic> map) {
    return PromoPackageValidDaysEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tprk2Id: map['tprk2Id'] != null ? map['tprk2Id'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoPackageValidDaysEntity.fromJson(String source) =>
      PromoPackageValidDaysEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoPackageValidDaysEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tprk2Id: $tprk2Id, day: $day, status: $status)';
  }

  @override
  bool operator ==(covariant PromoPackageValidDaysEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tprk2Id == tprk2Id &&
        other.day == day &&
        other.status == status;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tprk2Id.hashCode ^
        day.hashCode ^
        status.hashCode;
  }
}
