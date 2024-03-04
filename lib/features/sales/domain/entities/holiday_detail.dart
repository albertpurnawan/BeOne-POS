// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HolidayDetailEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tohldId;
  final DateTime holidayDate;
  final String description;
  final String descriptionFrgn;

  HolidayDetailEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tohldId,
    required this.holidayDate,
    required this.description,
    required this.descriptionFrgn,
  });

  HolidayDetailEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tohldId,
    DateTime? holidayDate,
    String? description,
    String? descriptionFrgn,
  }) {
    return HolidayDetailEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tohldId: tohldId ?? this.tohldId,
      holidayDate: holidayDate ?? this.holidayDate,
      description: description ?? this.description,
      descriptionFrgn: descriptionFrgn ?? this.descriptionFrgn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tohldId': tohldId,
      'holidayDate': holidayDate.millisecondsSinceEpoch,
      'description': description,
      'descriptionFrgn': descriptionFrgn,
    };
  }

  factory HolidayDetailEntity.fromMap(Map<String, dynamic> map) {
    return HolidayDetailEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tohldId: map['tohldId'] != null ? map['tohldId'] as String : null,
      holidayDate:
          DateTime.fromMillisecondsSinceEpoch(map['holidayDate'] as int),
      description: map['description'] as String,
      descriptionFrgn: map['descriptionFrgn'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HolidayDetailEntity.fromJson(String source) =>
      HolidayDetailEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HolidayDetailEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tohldId: $tohldId, holidayDate: $holidayDate, description: $description, descriptionFrgn: $descriptionFrgn)';
  }

  @override
  bool operator ==(covariant HolidayDetailEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tohldId == tohldId &&
        other.holidayDate == holidayDate &&
        other.description == description &&
        other.descriptionFrgn == descriptionFrgn;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tohldId.hashCode ^
        holidayDate.hashCode ^
        description.hashCode ^
        descriptionFrgn.hashCode;
  }
}
