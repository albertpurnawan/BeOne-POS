import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_group_item_customer_group.dart';

const String tablePromoDiskonGroupItemCustomerGroup = "tpdg5";

class PromoDiskonGroupItemCustomerGroupFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topdgId,
    tocrgId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topdgId = "topdgId";
  static const String tocrgId = "tocrgId";
}

class PromoDiskonGroupItemCustomerGroupModel
    extends PromoDiskonGroupItemCustomerGroupEntity implements BaseModel {
  PromoDiskonGroupItemCustomerGroupModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topdgId,
    required super.tocrgId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'topdgId': topdgId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoDiskonGroupItemCustomerGroupModel.fromMap(
      Map<String, dynamic> map) {
    return PromoDiskonGroupItemCustomerGroupModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      topdgId: map['topdgId'] != null ? map['topdgId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  factory PromoDiskonGroupItemCustomerGroupModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoDiskonGroupItemCustomerGroupModel.fromMap({
      ...map,
      'topdgId': map['topdgdocid'] != null ? map['topdgdocid'] as String : null,
      'tocrgId': map['tocrgdocid'] != null ? map['tocrgdocid'] as String : null,
    });
  }

  factory PromoDiskonGroupItemCustomerGroupModel.fromEntity(
      PromoDiskonGroupItemCustomerGroupEntity entity) {
    return PromoDiskonGroupItemCustomerGroupModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topdgId: entity.topdgId,
      tocrgId: entity.tocrgId,
    );
  }
}
