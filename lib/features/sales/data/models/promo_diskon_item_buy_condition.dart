import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_item_buy_condition.dart';

const String tablePromoDiskonItemBuyCondition = "tpdi1";

class PromoDiskonItemBuyConditionFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topdiId,
    toitmId,
    priceFrom,
    priceTo,
    qtyFrom,
    qtyTo,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topdiId = "topdiId";
  static const String toitmId = "toitmId";
  static const String priceFrom = "pricefrom";
  static const String priceTo = "priceto";
  static const String qtyFrom = "qtyfrom";
  static const String qtyTo = "qtyto";
}

class PromoDiskonItemBuyConditionModel extends PromoDiskonItemBuyConditionEntity
    implements BaseModel {
  PromoDiskonItemBuyConditionModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topdiId,
    required super.toitmId,
    required super.priceFrom,
    required super.priceTo,
    required super.qtyFrom,
    required super.qtyTo,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'topdiId': topdiId,
      'toitmId': toitmId,
      'pricefrom': priceFrom,
      'priceto': priceTo,
      'qtyfrom': qtyFrom,
      'qtyto': qtyTo,
    };
  }

  factory PromoDiskonItemBuyConditionModel.fromMap(Map<String, dynamic> map) {
    return PromoDiskonItemBuyConditionModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      topdiId: map['topdiId'] != null ? map['topdiId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      priceFrom: map['pricefrom'] != null ? map['pricefrom'] as double : null,
      priceTo: map['priceto'] != null ? map['priceto'] as double : null,
      qtyFrom: map['qtyfrom'] != null ? map['qtyfrom'] as double : null,
      qtyTo: map['qtyto'] != null ? map['qtyto'] as double : null,
    );
  }

  factory PromoDiskonItemBuyConditionModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoDiskonItemBuyConditionModel.fromMap({
      ...map,
      'pricefrom': map['pricefrom'] != null ? map['pricefrom'] as double : null,
      'priceto': map['priceto'] != null
          ? double.tryParse(map['priceto'].toString())
          : null,
      'qtyfrom': map['qtyfrom'] != null
          ? double.tryParse(map['qtyfrom'].toString())
          : null,
      'qtyto': map['qtyto'] != null
          ? double.tryParse(map['qtyto'].toString())
          : null,
    });
  }

  factory PromoDiskonItemBuyConditionModel.fromEntity(
      PromoDiskonItemBuyConditionEntity entity) {
    return PromoDiskonItemBuyConditionModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topdiId: entity.topdiId,
      toitmId: entity.toitmId,
      priceFrom: entity.priceFrom,
      priceTo: entity.priceTo,
      qtyFrom: entity.qtyFrom,
      qtyTo: entity.qtyTo,
    );
  }
}
