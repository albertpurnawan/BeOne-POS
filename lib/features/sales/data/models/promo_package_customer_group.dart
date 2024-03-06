import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_package_customer_group.dart';

const String tablePromoPackageCustomerGroup = "tprk4";

class PromoPackageCustomerGroupFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprkId,
    tocrgId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprkId = "toprkId";
  static const String tocrgId = "tocrgId";
}

class PromoPackageCustomerGroupModel extends PromoPackageCustomerGroupEntity
    implements BaseModel {
  PromoPackageCustomerGroupModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprkId,
    required super.tocrgId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprkId': toprkId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoPackageCustomerGroupModel.fromMap(Map<String, dynamic> map) {
    return PromoPackageCustomerGroupModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprkId: map['toprkId'] != null ? map['toprkId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  factory PromoPackageCustomerGroupModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoPackageCustomerGroupModel.fromMap({
      ...map,
      "toprkId": map['toprk_id']?['docid'] != null
          ? map['toprk_id']['docid'] as String
          : null,
      "tocrgId": map['tocrg_id']?['docid'] != null
          ? map['tocrg_id']['docid'] as String
          : null,
    });
  }

  factory PromoPackageCustomerGroupModel.fromEntity(
      PromoPackageCustomerGroupEntity entity) {
    return PromoPackageCustomerGroupModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprkId: entity.toprkId,
      tocrgId: entity.tocrgId,
    );
  }
}
