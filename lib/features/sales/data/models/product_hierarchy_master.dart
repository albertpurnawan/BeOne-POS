import 'package:pos_fe/features/sales/data/models/product_hierarchy.dart';
import 'package:pos_fe/features/sales/domain/entities/product_hierarchy_master.dart';

const String tableProductHierarchyMasters = "phir1";

class ProductHierarchyMasterFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    code,
    description,
    tphirId,
  ];

  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String code = 'code';
  static const String description = 'description';
  static const String tphirId = 'tphirId';
}

class ProductHierarchyMasterModel extends ProductHierarchyMasterEntity {
  ProductHierarchyMasterModel(
      {required super.docId,
      required super.createDate,
      required super.updateDate,
      required super.code,
      required super.description,
      required super.tphirId});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ProductHierarchyFields.docId: docId,
      ProductHierarchyMasterFields.createDate:
          createDate.toUtc().toIso8601String(),
      ProductHierarchyMasterFields.updateDate:
          updateDate?.toUtc().toIso8601String(),
      ProductHierarchyMasterFields.code: code,
      ProductHierarchyMasterFields.description: description,
      ProductHierarchyMasterFields.tphirId: tphirId,
    };
  }

  factory ProductHierarchyMasterModel.fromMapRemote(Map<String, dynamic> map) {
    return ProductHierarchyMasterModel.fromMap({
      ...map,
      "tphirId": map['tphirId']?['docid'] != null
          ? map['tphirId']['docid'] as String
          : null,
    });
  }

  factory ProductHierarchyMasterModel.fromMap(Map<String, dynamic> map) {
    return ProductHierarchyMasterModel(
      docId: map[ProductHierarchyFields.docId] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map[ProductHierarchyMasterFields.updateDate] != null
          ? DateTime.parse(
                  map[ProductHierarchyMasterFields.updateDate] as String)
              .toLocal()
          : null,
      code: map[ProductHierarchyMasterFields.code] as String,
      description: map[ProductHierarchyMasterFields.description] as String,
      tphirId: map[ProductHierarchyMasterFields.tphirId] != null
          ? map[ProductHierarchyMasterFields.tphirId] as String
          : null,
    );
  }

  factory ProductHierarchyMasterModel.fromEntity(
      ProductHierarchyMasterEntity entity) {
    return ProductHierarchyMasterModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      code: entity.code,
      description: entity.description,
      tphirId: entity.tphirId,
    );
  }
}
