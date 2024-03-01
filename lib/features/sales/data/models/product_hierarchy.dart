import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/product_hierarchy.dart';

const String tableProductHierarchies = "tphir";

class ProductHierarchyFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    description,
    level,
    maxChar
  ];

  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String description = 'description';
  static const String level = 'level';
  static const String maxChar = 'maxchar';
}

class ProductHierarchyModel extends ProductHierarchyEntity
    implements BaseModel {
  ProductHierarchyModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.description,
    required super.level,
    required super.maxChar,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'description': description,
      'level': level,
      'maxchar': maxChar,
    };
  }

  factory ProductHierarchyModel.fromMap(Map<String, dynamic> map) {
    return ProductHierarchyModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      description: map['description'] as String,
      level: map['level'] as int,
      maxChar: map['maxchar'] as int,
    );
  }

  factory ProductHierarchyModel.fromEntity(ProductHierarchyEntity entity) {
    return ProductHierarchyModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      description: entity.description,
      level: entity.level,
      maxChar: entity.maxChar,
    );
  }
}
