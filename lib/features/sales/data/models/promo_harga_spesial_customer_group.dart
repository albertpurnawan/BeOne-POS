import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_harga_spesial_customer_group.dart';

const String tablePromoHargaSpesialCustomerGroup = "tpsb4";

class PromoHargaSpesialCustomerGroupFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topsbId,
    tocrgId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topsbId = "topsbId";
  static const String tocrgId = "tocrgId";
}

class PromoHargaSpesialCustomerGroupModel
    extends PromoHargaSpesialCustomerGroupEntity implements BaseModel {
  PromoHargaSpesialCustomerGroupModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topsbId,
    required super.tocrgId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'topsbId': topsbId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoHargaSpesialCustomerGroupModel.fromMap(
      Map<String, dynamic> map) {
    return PromoHargaSpesialCustomerGroupModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      topsbId: map['topsbId'] != null ? map['topsbId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  factory PromoHargaSpesialCustomerGroupModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoHargaSpesialCustomerGroupModel.fromMap({
      ...map,
      'topsbId': map['topsbdocid'] != null ? map['topsbdocid'] as String : null,
      'tocrgId': map['tocrgdocid'] != null ? map['tocrgdocid'] as String : null,
    });
  }

  factory PromoHargaSpesialCustomerGroupModel.fromEntity(
      PromoHargaSpesialCustomerGroupEntity entity) {
    return PromoHargaSpesialCustomerGroupModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topsbId: entity.topsbId,
      tocrgId: entity.tocrgId,
    );
  }
}
