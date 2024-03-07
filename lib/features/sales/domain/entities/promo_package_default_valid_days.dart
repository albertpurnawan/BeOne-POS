// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoPackageDefaultValidDaysEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprkId;
  final int day;
  final int status;

  PromoPackageDefaultValidDaysEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprkId,
    required this.day,
    required this.status,
  });

  PromoPackageDefaultValidDaysEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprkId,
    int? day,
    int? status,
  }) {
    return PromoPackageDefaultValidDaysEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprkId: toprkId ?? this.toprkId,
      day: day ?? this.day,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprkId': toprkId,
      'day': day,
      'status': status,
    };
  }

  factory PromoPackageDefaultValidDaysEntity.fromMap(Map<String, dynamic> map) {
    return PromoPackageDefaultValidDaysEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprkId: map['toprkId'] != null ? map['toprkId'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoPackageDefaultValidDaysEntity.fromJson(String source) =>
      PromoPackageDefaultValidDaysEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoPackageDefaultValidDaysEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprkId: $toprkId, day: $day, status: $status)';
  }

  @override
  bool operator ==(covariant PromoPackageDefaultValidDaysEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprkId == toprkId &&
        other.day == day &&
        other.status == status;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprkId.hashCode ^
        day.hashCode ^
        status.hashCode;
  }
}
