import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_spesial_multi_item_customer_group.dart';

const String tablePromoSpesialMultiItemCustomerGroup = "tpsm4";

class PromoSpesialMultiItemCustomerGroupFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topsmId,
    tocrgId,
    form,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topsmId = "topsmId";
  static const String tocrgId = "tocrgId";
  static const String form = "form";
}

class PromoSpesialMultiItemCustomerGroupModel extends PromoSpesialMultiItemCustomerGroupEntity implements BaseModel {
  PromoSpesialMultiItemCustomerGroupModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topsmId,
    required super.tocrgId,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'topsmId': topsmId,
      'tocrgId': tocrgId,
      'form': form,
    };
  }

  factory PromoSpesialMultiItemCustomerGroupModel.fromMap(Map<String, dynamic> map) {
    return PromoSpesialMultiItemCustomerGroupModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate'] as String).toLocal() : null,
      topsmId: map['topsmId'] != null ? map['topsmId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
      form: map['form'] as String,
    );
  }

  factory PromoSpesialMultiItemCustomerGroupModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoSpesialMultiItemCustomerGroupModel.fromMap({
      ...map,
      'topsmId': map['topsmdocid'] != null ? map['topsmdocid'] as String : null,
      'tocrgId': map['tocrgdocid'] != null ? map['tocrgdocid'] as String : null,
    });
  }

  factory PromoSpesialMultiItemCustomerGroupModel.fromEntity(PromoSpesialMultiItemCustomerGroupEntity entity) {
    return PromoSpesialMultiItemCustomerGroupModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topsmId: entity.topsmId,
      tocrgId: entity.tocrgId,
      form: entity.form,
    );
  }
}
