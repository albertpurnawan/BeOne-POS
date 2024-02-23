import 'package:pos_fe/core/resources/data_sources_enum.dart';
import 'package:pos_fe/features/sales/domain/entities/item_category.dart';

const String tableItemCategories = "tocat";

class ItemCategoryFields {
  static const List<String> values = [
    id,
    docId,
    createDate,
    updateDate,
    catCode,
    catName,
    catNameFrgn,
    parentId,
    level,
    phir1Id,
  ];

  static const String id = "_id";
  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String catCode = "catcode";
  static const String catName = "catname";
  static const String catNameFrgn = "catnamefrgn";
  static const String parentId = "parentId";
  static const String level = "level";
  static const String phir1Id = "phir1Id";
}

class ItemCategoryModel extends ItemCategoryEntity {
  ItemCategoryModel({
    required super.id,
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.catCode,
    required super.catName,
    required super.catNameFrgn,
    required super.parentId,
    required super.level,
    required super.phir1Id,
  });

  factory ItemCategoryModel.fromMapByDataSource(
      DataSource dataSource, Map<String, dynamic> map) {
    return ItemCategoryModel(
      id: map[dataSource == DataSource.local ? '_id' : 'id'] as int,
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      catCode: map['catcode'] as String,
      catName: map['catname'] as String,
      catNameFrgn: map['catnamefrgn'] as String,
      parentId: map['parentId'] != null ? map['parentId'] as int : null,
      level: map['level'] as int,
      phir1Id: map['phir1Id'] != null ? map['phir1Id'] as int : null,
    );
  }

  Map<String, dynamic> toMapByDataSource(DataSource dataSource) {
    return <String, dynamic>{
      dataSource == DataSource.local ? '_id' : 'id': id,
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'catcode': catCode,
      'catname': catName,
      'catnamefrgn': catNameFrgn,
      'parentId': parentId,
      'level': level,
      'phir1Id': phir1Id,
    };
  }

  factory ItemCategoryModel.fromEntity(ItemCategoryEntity entity) {
    return ItemCategoryModel(
      id: entity.id,
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      catCode: entity.catCode,
      catName: entity.catName,
      catNameFrgn: entity.catNameFrgn,
      parentId: entity.parentId,
      level: entity.level,
      phir1Id: entity.phir1Id,
    );
  }
}
