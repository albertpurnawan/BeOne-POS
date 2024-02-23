import 'package:pos_fe/features/sales/domain/entities/product_hierarchy_master.dart';

const String tableProductHierarchyMasters = "phir1";

class ProductHierarchyMasterFields {
  static const List<String> values = [
    id,
    docId,
    createDate,
    updateDate,
    code,
    description,
    tphirId,
  ];

  static const String id = "id";
  static const String docId = "docid";
  static const String createDate = "createDate";
  static const String updateDate = "updateDate";
  static const String code = "code";
  static const String description = "description";
  static const String tphirId = "tphirId";
}

class ProductHierarchyMasterModel extends ProductHierarchyMasterEntity {
  ProductHierarchyMasterModel(
      {required super.id,
      required super.docId,
      required super.createDate,
      required super.updateDate,
      required super.code,
      required super.description,
      required super.tphirId});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'docid': docId,
      'createdate': createDate.toUtc().millisecondsSinceEpoch,
      'updatedate': updateDate?.toUtc().millisecondsSinceEpoch,
      'code': code,
      'description': description,
      'tphirId': tphirId,
    };
  }

  factory ProductHierarchyMasterModel.fromMap(Map<String, dynamic> map) {
    return ProductHierarchyMasterModel(
      id: map['_id'] as int,
      docId: map['docid'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createdate'] as int)
          .toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedate'] as int)
              .toLocal()
          : null,
      code: map['code'] as String,
      description: map['description'] as String,
      tphirId: map['tphirId'] != null ? map['tphirId'] as int : null,
    );
  }

  factory ProductHierarchyMasterModel.fromEntity(
      ProductHierarchyMasterEntity entity) {
    return ProductHierarchyMasterModel(
      id: entity.id,
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      code: entity.code,
      description: entity.description,
      tphirId: entity.tphirId,
    );
  }
}
