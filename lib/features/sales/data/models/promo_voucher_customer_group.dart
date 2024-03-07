import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_voucher_customer_group.dart';

const String tablePromoVoucherCustomerGroup = "tprr4";

class PromoVoucherCustomerGroupFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprrId,
    tocrgId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprrId = "toprrId";
  static const String tocrgId = "tocrgId";
}

class PromoVoucherCustomerGroupModel extends PromoVoucherCustomerGroupEntity
    implements BaseModel {
  PromoVoucherCustomerGroupModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprrId,
    required super.tocrgId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprrId': toprrId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoVoucherCustomerGroupModel.fromMap(Map<String, dynamic> map) {
    return PromoVoucherCustomerGroupModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprrId: map['toprrId'] != null ? map['toprrId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  factory PromoVoucherCustomerGroupModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoVoucherCustomerGroupModel.fromMap({
      ...map,
      "toprrId": map['toprr_id']?['docid'] != null
          ? map['toprr_id']['docid'] as String
          : null,
      "tocrgId": map['tocrg_id']?['docid'] != null
          ? map['tocrg_id']['docid'] as String
          : null,
    });
  }

  factory PromoVoucherCustomerGroupModel.fromEntity(
      PromoVoucherCustomerGroupEntity entity) {
    return PromoVoucherCustomerGroupModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprrId: entity.toprrId,
      tocrgId: entity.tocrgId,
    );
  }
}
