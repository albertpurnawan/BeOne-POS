// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoDiskonGroupItemAssignStoreEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topdgId;
  final String? tostrId;
  final int holiday;
  final int day1;
  final int day2;
  final int day3;
  final int day4;
  final int day5;
  final int day6;
  final int day7;

  PromoDiskonGroupItemAssignStoreEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.topdgId,
    required this.tostrId,
    required this.holiday,
    required this.day1,
    required this.day2,
    required this.day3,
    required this.day4,
    required this.day5,
    required this.day6,
    required this.day7,
  });

  PromoDiskonGroupItemAssignStoreEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topdgId,
    String? tostrId,
    int? holiday,
    int? day1,
    int? day2,
    int? day3,
    int? day4,
    int? day5,
    int? day6,
    int? day7,
  }) {
    return PromoDiskonGroupItemAssignStoreEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topdgId: topdgId ?? this.topdgId,
      tostrId: tostrId ?? this.tostrId,
      holiday: holiday ?? this.holiday,
      day1: day1 ?? this.day1,
      day2: day2 ?? this.day2,
      day3: day3 ?? this.day3,
      day4: day4 ?? this.day4,
      day5: day5 ?? this.day5,
      day6: day6 ?? this.day6,
      day7: day7 ?? this.day7,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'topdgId': topdgId,
      'tostrId': tostrId,
      'holiday': holiday,
      'day1': day1,
      'day2': day2,
      'day3': day3,
      'day4': day4,
      'day5': day5,
      'day6': day6,
      'day7': day7,
    };
  }

  factory PromoDiskonGroupItemAssignStoreEntity.fromMap(
      Map<String, dynamic> map) {
    return PromoDiskonGroupItemAssignStoreEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      topdgId: map['topdgId'] != null ? map['topdgId'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      holiday: map['holiday'] as int,
      day1: map['day1'] as int,
      day2: map['day2'] as int,
      day3: map['day3'] as int,
      day4: map['day4'] as int,
      day5: map['day5'] as int,
      day6: map['day6'] as int,
      day7: map['day7'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoDiskonGroupItemAssignStoreEntity.fromJson(String source) =>
      PromoDiskonGroupItemAssignStoreEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoDiskonGroupItemAssignStoreEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topdgId: $topdgId, tostrId: $tostrId, holiday: $holiday, day1: $day1, day2: $day2, day3: $day3, day4: $day4, day5: $day5, day6: $day6, day7: $day7)';
  }

  @override
  bool operator ==(covariant PromoDiskonGroupItemAssignStoreEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topdgId == topdgId &&
        other.tostrId == tostrId &&
        other.holiday == holiday &&
        other.day1 == day1 &&
        other.day2 == day2 &&
        other.day3 == day3 &&
        other.day4 == day4 &&
        other.day5 == day5 &&
        other.day6 == day6 &&
        other.day7 == day7;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        topdgId.hashCode ^
        tostrId.hashCode ^
        holiday.hashCode ^
        day1.hashCode ^
        day2.hashCode ^
        day3.hashCode ^
        day4.hashCode ^
        day5.hashCode ^
        day6.hashCode ^
        day7.hashCode;
  }
}
