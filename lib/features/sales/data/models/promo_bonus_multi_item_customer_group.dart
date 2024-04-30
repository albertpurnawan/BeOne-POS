import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_bonus_multi_item_customer_group.dart';

const String tablePromoBonusMultiItemCustomerGroup = "tpmi5";

class PromoBonusMultiItemCustomerGroupFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topmiId,
    tocrgId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topmiId = "topmiId";
  static const String tocrgId = "toitmId";
}

class PromoBonusMultiItemCustomerGroupModel
    extends PromoBonusMultiItemCustomerGroupEntity implements BaseModel {
  PromoBonusMultiItemCustomerGroupModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topmiId,
    required super.tocrgId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'topmiId': topmiId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoBonusMultiItemCustomerGroupModel.fromMap(
      Map<String, dynamic> map) {
    return PromoBonusMultiItemCustomerGroupModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      topmiId: map['topmiId'] != null ? map['topmiId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  factory PromoBonusMultiItemCustomerGroupModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoBonusMultiItemCustomerGroupModel.fromMap({
      ...map,
      'topmiId': map['topmidocid'] != null ? map['topmidocid'] as String : null,
      'tocrgId': map['tocrgdocid'] != null ? map['tocrgdocid'] as String : null,
    });
  }

  factory PromoBonusMultiItemCustomerGroupModel.fromEntity(
      PromoBonusMultiItemCustomerGroupEntity entity) {
    return PromoBonusMultiItemCustomerGroupModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topmiId: entity.topmiId,
      tocrgId: entity.tocrgId,
    );
  }
}
