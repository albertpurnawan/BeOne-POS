import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_group_item_buy_condition.dart';

const String tablePromoDiskonGroupItemBuyCondition = "tpdg1";

class PromoDiskonGroupItemBuyConditionFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topdgId,
    tocatId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topdgId = "topdgId";
  static const String tocatId = "tocatId";
}

class PromoDiskonGroupItemBuyConditionModel
    extends PromoDiskonGroupItemBuyConditionEntity implements BaseModel {
  PromoDiskonGroupItemBuyConditionModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topdgId,
    required super.tocatId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'topdgId': topdgId,
      'tocatId': tocatId,
    };
  }

  factory PromoDiskonGroupItemBuyConditionModel.fromMap(
      Map<String, dynamic> map) {
    return PromoDiskonGroupItemBuyConditionModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      topdgId: map['topdgId'] != null ? map['topdgId'] as String : null,
      tocatId: map['tocatId'] != null ? map['tocatId'] as String : null,
    );
  }

  factory PromoDiskonGroupItemBuyConditionModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoDiskonGroupItemBuyConditionModel.fromMap({
      ...map,
      'topdgId': map['topdgdocid'] != null ? map['topdgdocid'] as String : null,
      'tocatId': map['tocatdocid'] != null ? map['tocatdocid'] as String : null,
    });
  }

  factory PromoDiskonGroupItemBuyConditionModel.fromEntity(
      PromoDiskonGroupItemBuyConditionEntity entity) {
    return PromoDiskonGroupItemBuyConditionModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topdgId: entity.topdgId,
      tocatId: entity.tocatId,
    );
  }
}
