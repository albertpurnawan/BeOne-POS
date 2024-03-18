import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/item_picture.dart';

const String tableItemPicture = "tpitm";

class ItemPictureFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toitmId,
    picture,
    path,
  ];
  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toitmId = "toitmId";
  static const String picture = "picture";
  static const String path = "path";
}

class ItemPictureModel extends ItemPictureEntity implements BaseModel {
  ItemPictureModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toitmId,
    required super.picture,
    required super.path,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'toitmId': toitmId,
      'picture': picture,
      'path': path,
    };
  }

  factory ItemPictureModel.fromMap(Map<String, dynamic> map) {
    return ItemPictureModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updateDate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      picture: map['picture'] as dynamic,
      path: map['path'] != null ? map['path'] as String : null,
    );
  }

  factory ItemPictureModel.fromMapRemote(Map<String, dynamic> map) {
    return ItemPictureModel.fromMap({
      ...map,
      "toitmId": map['toitmdocid'] != null ? map['toitmdocid'] as String : null,
    });
  }

  factory ItemPictureModel.fromEntity(ItemPictureEntity entity) {
    return ItemPictureModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toitmId: entity.toitmId,
      picture: entity.picture,
      path: entity.path,
    );
  }
}
