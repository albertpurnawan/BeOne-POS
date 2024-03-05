// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoCreditCardValidDaysEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tprc2Id;
  final int day;
  final int status;

  PromoCreditCardValidDaysEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tprc2Id,
    required this.day,
    required this.status,
  });

  PromoCreditCardValidDaysEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tprc2Id,
    int? day,
    int? status,
  }) {
    return PromoCreditCardValidDaysEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tprc2Id: tprc2Id ?? this.tprc2Id,
      day: day ?? this.day,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tprc2Id': tprc2Id,
      'day': day,
      'status': status,
    };
  }

  factory PromoCreditCardValidDaysEntity.fromMap(Map<String, dynamic> map) {
    return PromoCreditCardValidDaysEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tprc2Id: map['tprc2Id'] != null ? map['tprc2Id'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoCreditCardValidDaysEntity.fromJson(String source) =>
      PromoCreditCardValidDaysEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoCreditCardValidDaysEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tprc2Id: $tprc2Id, day: $day, status: $status)';
  }

  @override
  bool operator ==(covariant PromoCreditCardValidDaysEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tprc2Id == tprc2Id &&
        other.day == day &&
        other.status == status;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tprc2Id.hashCode ^
        day.hashCode ^
        status.hashCode;
  }
}
