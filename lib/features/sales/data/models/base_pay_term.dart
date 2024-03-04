import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/base_pay_term.dart';

const String tableBasePayTerm = "tobpt";

class BasePayTermFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    baseCode,
    description,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String baseCode = "basecode";
  static const String description = "description";
}

class BasePayTermModel extends BasePayTermEntity implements BaseModel {
  BasePayTermModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.baseCode,
    required super.description,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'basecode': baseCode,
      'description': description,
    };
  }

  factory BasePayTermModel.fromMap(Map<String, dynamic> map) {
    return BasePayTermModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      baseCode: map['basecode'] as String,
      description: map['description'] as String,
    );
  }

  factory BasePayTermModel.fromEntity(BasePayTermEntity entity) {
    return BasePayTermModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      baseCode: entity.baseCode,
      description: entity.description,
    );
  }
}
