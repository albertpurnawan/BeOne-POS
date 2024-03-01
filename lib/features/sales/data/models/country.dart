import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/country.dart';

const String tableCountry = "tocry";

class CountryFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    countryCode,
    description,
    descriptionFrgn,
    phoneCode,
    tcurrId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String countryCode = "countrycode";
  static const String description = "description";
  static const String descriptionFrgn = "descriptionfrgn";
  static const String phoneCode = "phonecode";
  static const String tcurrId = "tcurrId";
}

class CountryModel extends CountryEntity implements BaseModel {
  CountryModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.countryCode,
    required super.description,
    required super.descriptionFrgn,
    required super.phoneCode,
    required super.tcurrId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'countrycode': countryCode,
      'description': description,
      'descriptionfrgn': descriptionFrgn,
      'phonecode': phoneCode,
      'tcurrId': tcurrId,
    };
  }

  factory CountryModel.fromMapRemote(Map<String, dynamic> map) {
    return CountryModel.fromMap({
      ...map,
      "tcurrId": map['tcurr_id']['docid'] != null
          ? map['tcurr_id']['docid'] as String
          : null,
    });
  }

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      countryCode: map['countrycode'] as String,
      description: map['description'] as String,
      descriptionFrgn: map['descriptionfrgn'] as String,
      phoneCode: map['phonecode'] as String,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
    );
  }

  factory CountryModel.fromEntity(CountryEntity entity) {
    return CountryModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      countryCode: entity.countryCode,
      description: entity.description,
      descriptionFrgn: entity.descriptionFrgn,
      phoneCode: entity.phoneCode,
      tcurrId: entity.tcurrId,
    );
  }
}
