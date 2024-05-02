import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_item_customer_group.dart';

const String tablePromoDiskonItemCustomerGroup = "tpdi5";

class PromoDiskonItemCustomerGroupFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topdiId,
    tocrgId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topdiId = "topdiId";
  static const String tocrgId = "tocrgid";
}

class PromoDiskonItemCustomerGroupModel
    extends PromoDiskonItemCustomerGroupEntity implements BaseModel {
  PromoDiskonItemCustomerGroupModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topdiId,
    required super.tocrgId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'topdiId': topdiId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoDiskonItemCustomerGroupModel.fromMap(Map<String, dynamic> map) {
    return PromoDiskonItemCustomerGroupModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      topdiId: map['topdiId'] != null ? map['topdiId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  factory PromoDiskonItemCustomerGroupModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoDiskonItemCustomerGroupModel.fromMap({
      ...map,
      'topdiId': map['topdidocid'] != null ? map['topdidocid'] as String : null,
      'tocrgId': map['tocrgdocid'] != null ? map['tocrgdocid'] as String : null,
    });
  }

  factory PromoDiskonItemCustomerGroupModel.fromEntity(
      PromoDiskonItemCustomerGroupEntity entity) {
    return PromoDiskonItemCustomerGroupModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topdiId: entity.topdiId,
      tocrgId: entity.tocrgId,
    );
  }
}
