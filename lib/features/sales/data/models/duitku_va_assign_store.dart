import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/duitku_va_assign_store.dart';

const String tableDuitkuVAAssignStore = "tpmt7";

class DuitkuVAAssignStoreFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tovalId,
    tostrId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tovalId = "tovalId";
  static const String tostrId = "tostrId";
}

class DuitkuVAAssignStoreModel extends DuitkuVAAssignStoreEntity implements BaseModel {
  DuitkuVAAssignStoreModel({
    required super.docId,
    super.createDate,
    super.updateDate,
    super.tovalId,
    super.tostrId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate?.toUtc().toIso8601String(),
      'updateDate': updateDate?.toUtc().toIso8601String(),
      'tovalId': tovalId,
      'tostrId': tostrId,
    };
  }

  factory DuitkuVAAssignStoreModel.fromMap(Map<String, dynamic> map) {
    return DuitkuVAAssignStoreModel(
      docId: map['docId'] as String,
      createDate: map['createdate'] != null ? DateTime.parse(map['createdate'] as String).toLocal() : null,
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate'] as String).toLocal() : null,
      tovalId: map['tovalId'] != null ? map['tovalId'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
    );
  }

  factory DuitkuVAAssignStoreModel.fromEntity(DuitkuVAAssignStoreEntity entity) {
    return DuitkuVAAssignStoreModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tovalId: entity.tovalId,
      tostrId: entity.tostrId,
    );
  }
}
