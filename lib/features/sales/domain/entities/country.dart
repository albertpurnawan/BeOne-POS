// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CountryEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String countryCode;
  final String description;
  final String descriptionFrgn;
  final String phoneCode;
  final String? tcurrId;

  CountryEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.countryCode,
    required this.description,
    required this.descriptionFrgn,
    required this.phoneCode,
    required this.tcurrId,
  });

  CountryEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? countryCode,
    String? description,
    String? descriptionFrgn,
    String? phoneCode,
    String? tcurrId,
  }) {
    return CountryEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      countryCode: countryCode ?? this.countryCode,
      description: description ?? this.description,
      descriptionFrgn: descriptionFrgn ?? this.descriptionFrgn,
      phoneCode: phoneCode ?? this.phoneCode,
      tcurrId: tcurrId ?? this.tcurrId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'countryCode': countryCode,
      'description': description,
      'descriptionFrgn': descriptionFrgn,
      'phoneCode': phoneCode,
      'tcurrId': tcurrId,
    };
  }

  factory CountryEntity.fromMap(Map<String, dynamic> map) {
    return CountryEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      countryCode: map['countryCode'] as String,
      description: map['description'] as String,
      descriptionFrgn: map['descriptionFrgn'] as String,
      phoneCode: map['phoneCode'] as String,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CountryEntity.fromJson(String source) =>
      CountryEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CountryEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, countryCode: $countryCode, description: $description, descriptionFrgn: $descriptionFrgn, phoneCode: $phoneCode, tcurrId: $tcurrId)';
  }

  @override
  bool operator ==(covariant CountryEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.countryCode == countryCode &&
        other.description == description &&
        other.descriptionFrgn == descriptionFrgn &&
        other.phoneCode == phoneCode &&
        other.tcurrId == tcurrId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        countryCode.hashCode ^
        description.hashCode ^
        descriptionFrgn.hashCode ^
        phoneCode.hashCode ^
        tcurrId.hashCode;
  }
}
