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

class CountryModel extends CountryEntity {
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
      'docId': docId,
      'createDate': createDate.toLocal().toIso8601String(),
      'updateDate': updateDate?.toLocal().toIso8601String(),
      'countryCode': countryCode,
      'description': description,
      'descriptionFrgn': descriptionFrgn,
      'phoneCode': phoneCode,
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
      docId: map['docId'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updateDate'] != null
          ? DateTime.parse(map['createdate']).toLocal()
          : null,
      countryCode: map['countryCode'] as String,
      description: map['description'] as String,
      descriptionFrgn: map['descriptionFrgn'] as String,
      phoneCode: map['phoneCode'] as String,
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
