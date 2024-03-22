// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoBertingkatValidDaysEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tprp2Id;
  final int day;
  final int status;

  PromoBertingkatValidDaysEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tprp2Id,
    required this.day,
    required this.status,
  });

  PromoBertingkatValidDaysEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tprp2Id,
    int? day,
    int? status,
  }) {
    return PromoBertingkatValidDaysEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tprp2Id: tprp2Id ?? this.tprp2Id,
      day: day ?? this.day,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tprp2Id': tprp2Id,
      'day': day,
      'status': status,
    };
  }

  factory PromoBertingkatValidDaysEntity.fromMap(Map<String, dynamic> map) {
    return PromoBertingkatValidDaysEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tprp2Id: map['tprp2Id'] != null ? map['tprp2Id'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBertingkatValidDaysEntity.fromJson(String source) =>
      PromoBertingkatValidDaysEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBertingkatValidDaysEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tprp2Id: $tprp2Id, day: $day, status: $status)';
  }

  @override
  bool operator ==(covariant PromoBertingkatValidDaysEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tprp2Id == tprp2Id &&
        other.day == day &&
        other.status == status;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tprp2Id.hashCode ^
        day.hashCode ^
        status.hashCode;
  }
}