// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoBuyXGetYValidDaysEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tprb2Id;
  final int day;
  final int status;

  PromoBuyXGetYValidDaysEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tprb2Id,
    required this.day,
    required this.status,
  });

  PromoBuyXGetYValidDaysEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tprb2Id,
    int? day,
    int? status,
  }) {
    return PromoBuyXGetYValidDaysEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tprb2Id: tprb2Id ?? this.tprb2Id,
      day: day ?? this.day,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tprb2Id': tprb2Id,
      'day': day,
      'status': status,
    };
  }

  factory PromoBuyXGetYValidDaysEntity.fromMap(Map<String, dynamic> map) {
    return PromoBuyXGetYValidDaysEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tprb2Id: map['tprb2Id'] != null ? map['tprb2Id'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBuyXGetYValidDaysEntity.fromJson(String source) =>
      PromoBuyXGetYValidDaysEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBuyXGetYValidDaysEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tprb2Id: $tprb2Id, day: $day, status: $status)';
  }

  @override
  bool operator ==(covariant PromoBuyXGetYValidDaysEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tprb2Id == tprb2Id &&
        other.day == day &&
        other.status == status;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tprb2Id.hashCode ^
        day.hashCode ^
        status.hashCode;
  }
}
