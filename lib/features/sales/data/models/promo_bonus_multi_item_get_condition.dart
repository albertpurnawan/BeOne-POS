import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_bonus_multi_item_get_condition.dart';

const String tablePromoBonusMultiItemGetCondition = "tpmi4";

class PromoBonusMultiItemGetConditionFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topmiId,
    toitmId,
    quantity,
    price,
    quota,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topmiId = "topmiId";
  static const String toitmId = "toitmId";
  static const String quantity = "quantity";
  static const String price = "price";
  static const String quota = "quota";
}

class PromoBonusMultiItemGetConditionModel
    extends PromoBonusMultiItemGetConditionEntity implements BaseModel {
  PromoBonusMultiItemGetConditionModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topmiId,
    required super.toitmId,
    required super.quantity,
    required super.price,
    required super.quota,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'topmiId': topmiId,
      'toitmId': toitmId,
      'quantity': quantity,
      'price': price,
      'quota': quota,
    };
  }

  factory PromoBonusMultiItemGetConditionModel.fromMap(
      Map<String, dynamic> map) {
    return PromoBonusMultiItemGetConditionModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      topmiId: map['topmiId'] != null ? map['topmiId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      price: map['price'] as double,
      quota: map['quota'] as double,
    );
  }

  factory PromoBonusMultiItemGetConditionModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoBonusMultiItemGetConditionModel.fromMap({
      ...map,
      'topmiId': map['topmidocid'] != null ? map['topmidocid'] as String : null,
      'toitmId': map['toitmdocid'] != null ? map['toitmdocid'] as String : null,
    });
  }

  factory PromoBonusMultiItemGetConditionModel.fromEntity(
      PromoBonusMultiItemGetConditionEntity entity) {
    return PromoBonusMultiItemGetConditionModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topmiId: entity.topmiId,
      toitmId: entity.toitmId,
      quantity: entity.quantity,
      price: entity.price,
      quota: entity.quota,
    );
  }
}
