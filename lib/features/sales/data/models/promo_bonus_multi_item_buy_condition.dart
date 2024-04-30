import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_bonus_multi_item_buy_condition.dart';

const String tablePromoBonusMultiItemBuyCondition = "tpmi1";

class PromoBonusMultiItemBuyConditionFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topmiId,
    toitmId,
    qtyFrom,
    qtyTo,
    priceFrom,
    priceTo,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topmiId = "topmiId";
  static const String toitmId = "toitmId";
  static const String qtyFrom = "qtyfrom";
  static const String qtyTo = "qtyto";
  static const String priceFrom = "pricefrom";
  static const String priceTo = "priceto";
}

class PromoBonusMultiItemBuyConditionModel
    extends PromoBonusMultiItemBuyConditionEntity implements BaseModel {
  PromoBonusMultiItemBuyConditionModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topmiId,
    required super.toitmId,
    required super.qtyFrom,
    required super.qtyTo,
    required super.priceFrom,
    required super.priceTo,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'topmiId': topmiId,
      'toitmId': toitmId,
      'qtyfrom': qtyFrom,
      'qtyto': qtyTo,
      'pricefrom': priceFrom,
      'priceto': priceTo,
    };
  }

  factory PromoBonusMultiItemBuyConditionModel.fromMap(
      Map<String, dynamic> map) {
    return PromoBonusMultiItemBuyConditionModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      topmiId: map['topmiId'] != null ? map['topmiId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      qtyFrom: map['qtyfrom'] != null ? map['qtyfrom'] as double : null,
      qtyTo: map['qtyto'] != null ? map['qtyto'] as double : null,
      priceFrom: map['pricefrom'] != null ? map['pricefrom'] as double : null,
      priceTo: map['priceto'] != null ? map['priceto'] as double : null,
    );
  }

  factory PromoBonusMultiItemBuyConditionModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoBonusMultiItemBuyConditionModel.fromMap({
      ...map,
      'topmiId': map['topmidocid'] != null ? map['topmidocid'] as String : null,
      'toitmId': map['toitmdocid'] != null ? map['toitmdocid'] as String : null,
      'qtyfrom': map['qtyfrom'] != null
          ? double.tryParse(map['qtyfrom'].toString())
          : null,
      'qtyto': map['qtyto'] != null
          ? double.tryParse(map['qtyto'].toString())
          : null,
      'pricefrom': map['pricefrom'] != null
          ? double.tryParse(map['pricefrom'].toString())
          : null,
      'priceto': map['priceto'] != null
          ? double.tryParse(map['priceto'].toString())
          : null,
    });
  }

  factory PromoBonusMultiItemBuyConditionModel.fromEntity(
      PromoBonusMultiItemBuyConditionEntity entity) {
    return PromoBonusMultiItemBuyConditionModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topmiId: entity.topmiId,
      toitmId: entity.toitmId,
      qtyFrom: entity.qtyFrom,
      qtyTo: entity.qtyTo,
      priceFrom: entity.priceFrom,
      priceTo: entity.priceTo,
    );
  }
}
