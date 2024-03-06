// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoVoucherValidDaysEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tprr2Id;
  final int day;
  final int status;

  PromoVoucherValidDaysEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tprr2Id,
    required this.day,
    required this.status,
  });

  PromoVoucherValidDaysEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tprr2Id,
    int? day,
    int? status,
  }) {
    return PromoVoucherValidDaysEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tprr2Id: tprr2Id ?? this.tprr2Id,
      day: day ?? this.day,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tprr2Id': tprr2Id,
      'day': day,
      'status': status,
    };
  }

  factory PromoVoucherValidDaysEntity.fromMap(Map<String, dynamic> map) {
    return PromoVoucherValidDaysEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tprr2Id: map['tprr2Id'] != null ? map['tprr2Id'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoVoucherValidDaysEntity.fromJson(String source) =>
      PromoVoucherValidDaysEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoVoucherValidDaysEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tprr2Id: $tprr2Id, day: $day, status: $status)';
  }

  @override
  bool operator ==(covariant PromoVoucherValidDaysEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tprr2Id == tprr2Id &&
        other.day == day &&
        other.status == status;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tprr2Id.hashCode ^
        day.hashCode ^
        status.hashCode;
  }
}
