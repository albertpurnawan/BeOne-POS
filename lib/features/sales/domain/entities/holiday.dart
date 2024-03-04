// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HolidayEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String calendarCode;
  final String description;
  final String descriptionFrgn;
  final int fiscalYear;

  HolidayEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.calendarCode,
    required this.description,
    required this.descriptionFrgn,
    required this.fiscalYear,
  });

  HolidayEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? calendarCode,
    String? description,
    String? descriptionFrgn,
    int? fiscalYear,
  }) {
    return HolidayEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      calendarCode: calendarCode ?? this.calendarCode,
      description: description ?? this.description,
      descriptionFrgn: descriptionFrgn ?? this.descriptionFrgn,
      fiscalYear: fiscalYear ?? this.fiscalYear,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'calendarCode': calendarCode,
      'description': description,
      'descriptionFrgn': descriptionFrgn,
      'fiscalYear': fiscalYear,
    };
  }

  factory HolidayEntity.fromMap(Map<String, dynamic> map) {
    return HolidayEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      calendarCode: map['calendarCode'] as String,
      description: map['description'] as String,
      descriptionFrgn: map['descriptionFrgn'] as String,
      fiscalYear: map['fiscalYear'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory HolidayEntity.fromJson(String source) =>
      HolidayEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HolidayEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, calendarCode: $calendarCode, description: $description, descriptionFrgn: $descriptionFrgn, fiscalYear: $fiscalYear)';
  }

  @override
  bool operator ==(covariant HolidayEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.calendarCode == calendarCode &&
        other.description == description &&
        other.descriptionFrgn == descriptionFrgn &&
        other.fiscalYear == fiscalYear;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        calendarCode.hashCode ^
        description.hashCode ^
        descriptionFrgn.hashCode ^
        fiscalYear.hashCode;
  }
}
