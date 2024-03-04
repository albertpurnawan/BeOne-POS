import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/gender.dart';

const String tableGender = "togen";

class GenderFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    genderCode,
    description,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String genderCode = "gendercode";
  static const String description = "description";
}

class GenderModel extends GenderEntity implements BaseModel {
  GenderModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.genderCode,
    required super.description,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'gendercode': genderCode,
      'description': description,
    };
  }

  factory GenderModel.fromMap(Map<String, dynamic> map) {
    return GenderModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      genderCode: map['gendercode'] as String,
      description: map['description'] as String,
    );
  }

  factory GenderModel.fromEntity(GenderEntity entity) {
    return GenderModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      genderCode: entity.genderCode,
      description: entity.description,
    );
  }
}
