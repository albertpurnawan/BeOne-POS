// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoCreditCardDefaultValidDaysEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprcId;
  final int day;
  final int status;

  PromoCreditCardDefaultValidDaysEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprcId,
    required this.day,
    required this.status,
  });

  PromoCreditCardDefaultValidDaysEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprcId,
    int? day,
    int? status,
  }) {
    return PromoCreditCardDefaultValidDaysEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprcId: toprcId ?? this.toprcId,
      day: day ?? this.day,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprcId': toprcId,
      'day': day,
      'status': status,
    };
  }

  factory PromoCreditCardDefaultValidDaysEntity.fromMap(
      Map<String, dynamic> map) {
    return PromoCreditCardDefaultValidDaysEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprcId: map['toprcId'] != null ? map['toprcId'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoCreditCardDefaultValidDaysEntity.fromJson(String source) =>
      PromoCreditCardDefaultValidDaysEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoCreditCardDefaultValidDaysEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprcId: $toprcId, day: $day, status: $status)';
  }

  @override
  bool operator ==(covariant PromoCreditCardDefaultValidDaysEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprcId == toprcId &&
        other.day == day &&
        other.status == status;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprcId.hashCode ^
        day.hashCode ^
        status.hashCode;
  }
}
