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
  final String form;

  CountryEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    required this.countryCode,
    required this.description,
    required this.descriptionFrgn,
    required this.phoneCode,
    this.tcurrId,
    required this.form,
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
    String? form,
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
      form: form ?? this.form,
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
      'form': form,
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
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CountryEntity.fromJson(String source) =>
      CountryEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CountryEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, countryCode: $countryCode, description: $description, descriptionFrgn: $descriptionFrgn, phoneCode: $phoneCode, tcurrId: $tcurrId, form: $form)';
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
        other.tcurrId == tcurrId &&
        other.form == form;
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
        tcurrId.hashCode ^
        form.hashCode;
  }
}
