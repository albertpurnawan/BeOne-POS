import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/province.dart';

const String tableProvince = "toprv";

class ProvinceFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    provncCode,
    description,
    descriptionFrgn,
    tocryId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String provncCode = "provnccode";
  static const String description = "description";
  static const String descriptionFrgn = "descriptionFrgn";
  static const String tocryId = "tocryId";
}

class ProvinceModel extends ProvinceEntity implements BaseModel {
  ProvinceModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.provncCode,
    required super.description,
    required super.descriptionFrgn,
    required super.tocryId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'provnccode': provncCode,
      'description': description,
      'descriptionfrgn': descriptionFrgn,
      'tocryId': tocryId,
    };
  }

  factory ProvinceModel.fromMapRemote(Map<String, dynamic> map) {
    return ProvinceModel.fromMap({
      ...map,
      "tocryId": map['tocry_id']['docid'] != null
          ? map['tocry_id']['docid'] as String
          : null,
    });
  }

  factory ProvinceModel.fromMap(Map<String, dynamic> map) {
    return ProvinceModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      provncCode: map['provnccode'] as String,
      description: map['description'] as String,
      descriptionFrgn: map['descriptionFrgn'] as String,
      tocryId: map['tocryId'] != null ? map['tocryId'] as String : null,
    );
  }

  factory ProvinceModel.fromEntity(ProvinceEntity entity) {
    return ProvinceModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      provncCode: entity.provncCode,
      description: entity.description,
      descriptionFrgn: entity.descriptionFrgn,
      tocryId: entity.tocryId,
    );
  }
}
