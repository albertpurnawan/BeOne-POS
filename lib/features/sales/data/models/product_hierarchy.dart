import 'package:pos_fe/features/sales/domain/entities/product_hierarchy.dart';

const String tableProductHierarchies = "tphir";

class ProductHierarchyFields {
  static const List<String> values = [
    id,
    docId,
    createDate,
    updateDate,
    description,
    level,
    maxChar
  ];

  static const String id = '_id';
  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String description = 'description';
  static const String level = 'level';
  static const String maxChar = 'maxchar';
}

class ProductHierarchyModel extends ProductHierarchyEntity {
  ProductHierarchyModel({
    required super.id,
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
      '_id': id,
      'docid': docId,
      'createdate': createDate.toUtc().millisecondsSinceEpoch,
      'updatedate': updateDate?.toUtc().millisecondsSinceEpoch,
      'description': description,
      'level': level,
      'maxchar': maxChar,
    };
  }

  factory ProductHierarchyModel.fromMap(Map<String, dynamic> map) {
    return ProductHierarchyModel(
      id: map['_id'] as int, // id not returned
      docId: map['docid'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createdate'] as int)
          .toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedate'] as int)
              .toLocal()
          : null,
      description: map['description'] as String,
      level: map['level'] as int,
      maxChar: map['maxchar'] as int,
    );
  }

  factory ProductHierarchyModel.fromEntity(ProductHierarchyEntity entity) {
    return ProductHierarchyModel(
      id: entity.id,
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      description: entity.description,
      level: entity.level,
      maxChar: entity.maxChar,
    );
  }
}
