import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_gwp_customer_group.dart';

const String tablePromoGWPCustomerGroup = "tprg4";

class PromoGWPCustomerGroupFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprgId,
    tocrgId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprgId = "toprgId";
  static const String tocrgId = "tocrgId";
}

class PromoGWPCustomerGroupModel extends PromoGWPCustomerGroupEntity
    implements BaseModel {
  PromoGWPCustomerGroupModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprgId,
    required super.tocrgId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprgId': toprgId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoGWPCustomerGroupModel.fromMap(Map<String, dynamic> map) {
    return PromoGWPCustomerGroupModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprgId: map['toprgId'] != null ? map['toprgId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  factory PromoGWPCustomerGroupModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoGWPCustomerGroupModel.fromMap({
      ...map,
      "toprgId": map['toprg_id']?['docid'] != null
          ? map['toprg_id']['docid'] as String
          : null,
      "tocrgId": map['tocrg_id']?['docid'] != null
          ? map['tocrg_id']['docid'] as String
          : null,
    });
  }

  factory PromoGWPCustomerGroupModel.fromEntity(
      PromoGWPCustomerGroupEntity entity) {
    return PromoGWPCustomerGroupModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprgId: entity.toprgId,
      tocrgId: entity.tocrgId,
    );
  }
}
