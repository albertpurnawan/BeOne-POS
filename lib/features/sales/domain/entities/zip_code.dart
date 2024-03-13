// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ZipCodeEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String zipCode;
  final String city;
  final String district;
  final String? urban;
  final String subDistrict;
  final String? toprvId;

  ZipCodeEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.zipCode,
    required this.city,
    required this.district,
    required this.urban,
    required this.subDistrict,
    required this.toprvId,
  });

  ZipCodeEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? zipCode,
    String? city,
    String? district,
    String? urban,
    String? subDistrict,
    String? toprvId,
  }) {
    return ZipCodeEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      zipCode: zipCode ?? this.zipCode,
      city: city ?? this.city,
      district: district ?? this.district,
      urban: urban ?? this.urban,
      subDistrict: subDistrict ?? this.subDistrict,
      toprvId: toprvId ?? this.toprvId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'zipCode': zipCode,
      'city': city,
      'district': district,
      'urban': urban,
      'subDistrict': subDistrict,
      'toprvId': toprvId,
    };
  }

  factory ZipCodeEntity.fromMap(Map<String, dynamic> map) {
    return ZipCodeEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      zipCode: map['zipCode'] as String,
      city: map['city'] as String,
      district: map['district'] as String,
      urban: map['urban'] as String,
      subDistrict:
          map['subDistrict'] != null ? map['subDistrict'] as String : "",
      toprvId: map['toprvId'] != null ? map['toprvId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ZipCodeEntity.fromJson(String source) =>
      ZipCodeEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ZipCodeEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, zipCode: $zipCode, city: $city, district: $district, urban: $urban, subDistrict: $subDistrict, toprvId: $toprvId)';
  }

  @override
  bool operator ==(covariant ZipCodeEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.zipCode == zipCode &&
        other.city == city &&
        other.district == district &&
        other.urban == urban &&
        other.subDistrict == subDistrict &&
        other.toprvId == toprvId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        zipCode.hashCode ^
        city.hashCode ^
        district.hashCode ^
        urban.hashCode ^
        subDistrict.hashCode ^
        toprvId.hashCode;
  }
}
