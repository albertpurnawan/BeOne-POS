import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/zip_code.dart';

const String tableZipCode = 'tozcd';

class ZipCodeFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    zipCode,
    city,
    district,
    urban,
    subDistrict,
    toprvId,
    form,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String zipCode = "zipcode";
  static const String city = "city";
  static const String district = "district";
  static const String urban = "urban";
  static const String subDistrict = "subdistrict";
  static const String toprvId = "toprvId";
  static const String form = "form";
}

class ZipCodeModel extends ZipCodeEntity implements BaseModel {
  ZipCodeModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.zipCode,
    required super.city,
    required super.district,
    required super.urban,
    required super.subDistrict,
    required super.toprvId,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'zipcode': zipCode,
      'city': city,
      'district': district,
      'urban': urban,
      'subdistrict': subDistrict,
      'toprvId': toprvId,
      'form': form,
    };
  }

  factory ZipCodeModel.fromMap(Map<String, dynamic> map) {
    return ZipCodeModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      zipCode: map['zipcode'] as String,
      city: map['city'] as String,
      district: map['district'] as String,
      urban: map['urban'] as String,
      subDistrict:
          map['subdistrict'] != null ? map['subdistrict'] as String : "",
      toprvId: map['toprvId'] != null ? map['toprvId'] as String : null,
      form: map['form'] as String,
    );
  }

  factory ZipCodeModel.fromMapRemote(Map<String, dynamic> map) {
    return ZipCodeModel.fromMap({
      ...map,
      "toprvId": map['toprvdocid'] != null ? map['toprvdocid'] as String : null,
    });
  }

  factory ZipCodeModel.fromEntity(ZipCodeEntity entity) {
    return ZipCodeModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      zipCode: entity.zipCode,
      city: entity.city,
      district: entity.district,
      urban: entity.urban,
      subDistrict: entity.subDistrict,
      toprvId: entity.toprvId,
      form: entity.form,
    );
  }
}
