import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/item_remark.dart';

const String tableItemRemarks = "tritm";

class ItemRemarksFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toitmId,
    remarks,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toitmId = "toitmId";
  static const String remarks = "remarks";
}

class ItemRemarksModel extends ItemRemarkEntity implements BaseModel {
  ItemRemarksModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toitmId,
    required super.remarks,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'toitmId': toitmId,
      'remarks': remarks,
    };
  }

  factory ItemRemarksModel.fromMap(Map<String, dynamic> map) {
    return ItemRemarksModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
    );
  }

  factory ItemRemarksModel.fromMapRemote(Map<String, dynamic> map) {
    return ItemRemarksModel.fromMap({
      ...map,
      "toitmId": map['toitmdocid'] != null ? map['toitmdocid'] as String : null,
    });
  }

  factory ItemRemarksModel.fromEntity(ItemRemarkEntity entity) {
    return ItemRemarksModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toitmId: entity.toitmId,
      remarks: entity.remarks,
    );
  }
}
