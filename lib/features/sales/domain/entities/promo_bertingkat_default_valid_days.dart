// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoBertingkatDefaultValidDaysEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprpId;
  final int day;
  final int status;

  PromoBertingkatDefaultValidDaysEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprpId,
    required this.day,
    required this.status,
  });

  PromoBertingkatDefaultValidDaysEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprpId,
    int? day,
    int? status,
  }) {
    return PromoBertingkatDefaultValidDaysEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprpId: toprpId ?? this.toprpId,
      day: day ?? this.day,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprpId': toprpId,
      'day': day,
      'status': status,
    };
  }

  factory PromoBertingkatDefaultValidDaysEntity.fromMap(
      Map<String, dynamic> map) {
    return PromoBertingkatDefaultValidDaysEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprpId: map['toprpId'] != null ? map['toprpId'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBertingkatDefaultValidDaysEntity.fromJson(String source) =>
      PromoBertingkatDefaultValidDaysEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBertingkatDefaultValidDaysEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprpId: $toprpId, day: $day, status: $status)';
  }

  @override
  bool operator ==(covariant PromoBertingkatDefaultValidDaysEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprpId == toprpId &&
        other.day == day &&
        other.status == status;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprpId.hashCode ^
        day.hashCode ^
        status.hashCode;
  }
}
