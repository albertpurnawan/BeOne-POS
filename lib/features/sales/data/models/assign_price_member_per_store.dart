import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/assign_price_member_per_store.dart';

const String tableAPMPS = "tpln3";

class AssignPriceMemberPerStoreFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toplnId,
    tostrId,
    statusActive,
    activated,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toplnId = "toplnId";
  static const String tostrId = "tostrId";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
}

class AssignPriceMemberPerStoreModel extends AssignPriceMemberPerStoreEntity
    implements BaseModel {
  AssignPriceMemberPerStoreModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toplnId,
    required super.tostrId,
    required super.statusActive,
    required super.activated,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'toplnId': toplnId,
      'tostrId': tostrId,
      'statusactive': statusActive,
      'activated': activated,
    };
  }

  factory AssignPriceMemberPerStoreModel.fromMap(Map<String, dynamic> map) {
    return AssignPriceMemberPerStoreModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
    );
  }

  factory AssignPriceMemberPerStoreModel.fromMapRemote(
      Map<String, dynamic> map) {
    return AssignPriceMemberPerStoreModel.fromMap({
      ...map,
      "toplnId": map['toplndocid'] != null ? map['toplndocid'] as String : null,
      "tostrId": map['tostrdocid'] != null ? map['tostrdocid'] as String : null,
    });
  }

  factory AssignPriceMemberPerStoreModel.fromEntity(
      AssignPriceMemberPerStoreEntity entity) {
    return AssignPriceMemberPerStoreModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toplnId: entity.toplnId,
      tostrId: entity.tostrId,
      statusActive: entity.statusActive,
      activated: entity.activated,
    );
  }
}
