import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/item_property.dart';

const String tableItemProperty = "tprop";

class ItemPropertyFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    properties,
    code,
    description,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String properties = "properties";
  static const String code = "code";
  static const String description = "description";
}

class ItemPropertyModel extends ItemPropertyEntity implements BaseModel {
  ItemPropertyModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.properties,
    required super.code,
    required super.description,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'properties': properties,
      'code': code,
      'description': description,
    };
  }

  factory ItemPropertyModel.fromMap(Map<String, dynamic> map) {
    return ItemPropertyModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      properties: map['properties'] as String,
      code: map['code'] as String,
      description: map['description'] as String,
    );
  }

  factory ItemPropertyModel.fromEntity(ItemPropertyEntity entity) {
    return ItemPropertyModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      properties: entity.properties,
      code: entity.code,
      description: entity.description,
    );
  }
}
