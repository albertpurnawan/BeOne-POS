// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoCouponAssignStoreEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprnId;
  final String? tostrId;
  final int holiday;
  final int day1;
  final int day2;
  final int day3;
  final int day4;
  final int day5;
  final int day6;
  final int day7;
  final String form;

  PromoCouponAssignStoreEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.toprnId,
    this.tostrId,
    required this.holiday,
    required this.day1,
    required this.day2,
    required this.day3,
    required this.day4,
    required this.day5,
    required this.day6,
    required this.day7,
    required this.form,
  });

  PromoCouponAssignStoreEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprnId,
    String? tostrId,
    int? holiday,
    int? day1,
    int? day2,
    int? day3,
    int? day4,
    int? day5,
    int? day6,
    int? day7,
    String? form,
  }) {
    return PromoCouponAssignStoreEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprnId: toprnId ?? this.toprnId,
      tostrId: tostrId ?? this.tostrId,
      holiday: holiday ?? this.holiday,
      day1: day1 ?? this.day1,
      day2: day2 ?? this.day2,
      day3: day3 ?? this.day3,
      day4: day4 ?? this.day4,
      day5: day5 ?? this.day5,
      day6: day6 ?? this.day6,
      day7: day7 ?? this.day7,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprnId': toprnId,
      'tostrId': tostrId,
      'holiday': holiday,
      'day1': day1,
      'day2': day2,
      'day3': day3,
      'day4': day4,
      'day5': day5,
      'day6': day6,
      'day7': day7,
      'form': form,
    };
  }

  factory PromoCouponAssignStoreEntity.fromMap(Map<String, dynamic> map) {
    return PromoCouponAssignStoreEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int) : null,
      toprnId: map['toprnId'] != null ? map['toprnId'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      holiday: map['holiday'] as int,
      day1: map['day1'] as int,
      day2: map['day2'] as int,
      day3: map['day3'] as int,
      day4: map['day4'] as int,
      day5: map['day5'] as int,
      day6: map['day6'] as int,
      day7: map['day7'] as int,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoCouponAssignStoreEntity.fromJson(String source) =>
      PromoCouponAssignStoreEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoCouponAssignStoreEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprnId: $toprnId, tostrId: $tostrId, holiday: $holiday, day1: $day1, day2: $day2, day3: $day3, day4: $day4, day5: $day5, day6: $day6, day7: $day7, form: $form)';
  }

  @override
  bool operator ==(covariant PromoCouponAssignStoreEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprnId == toprnId &&
        other.tostrId == tostrId &&
        other.holiday == holiday &&
        other.day1 == day1 &&
        other.day2 == day2 &&
        other.day3 == day3 &&
        other.day4 == day4 &&
        other.day5 == day5 &&
        other.day6 == day6 &&
        other.day7 == day7 &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprnId.hashCode ^
        tostrId.hashCode ^
        holiday.hashCode ^
        day1.hashCode ^
        day2.hashCode ^
        day3.hashCode ^
        day4.hashCode ^
        day5.hashCode ^
        day6.hashCode ^
        day7.hashCode ^
        form.hashCode;
  }
}
