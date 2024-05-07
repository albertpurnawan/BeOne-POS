import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_buy_condition.dart';

const String tablePromoBuyXGetYBuyCondition = "tprb1";

class PromoBuyXGetYBuyConditionFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprbId,
    toitmId,
    quantity,
    itemPrice,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprbId = "toprbId";
  static const String toitmId = "toitmId";
  static const String quantity = "quantity";
  static const String itemPrice = "itemprice";
}

class PromoBuyXGetYBuyConditionModel extends PromoBuyXGetYBuyConditionEntity
    implements BaseModel {
  PromoBuyXGetYBuyConditionModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprbId,
    required super.toitmId,
    required super.quantity,
    required super.itemPrice,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprbId': toprbId,
      'toitmId': toitmId,
      'quantity': quantity,
      'itemprice': itemPrice,
    };
  }

  factory PromoBuyXGetYBuyConditionModel.fromMap(Map<String, dynamic> map) {
    return PromoBuyXGetYBuyConditionModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprbId: map['toprbId'] != null ? map['toprbId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      itemPrice: map['itemprice'] != null ? map['itemprice'] as double : null,
    );
  }

  factory PromoBuyXGetYBuyConditionModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoBuyXGetYBuyConditionModel.fromMap({
      ...map,
      "toprbId": map['toprbdocid'] != null ? map['toprbdocid'] as String : null,
      "toitmId": map['toitmdocid'] != null ? map['toitmdocid'] as String : null,
      "quantity": double.tryParse(map['quantity'].toString()),
      "itemprice": map['itemprice'] != null
          ? double.tryParse(map['itemprice'].toString())
          : null,
    });
  }

  factory PromoBuyXGetYBuyConditionModel.fromEntity(
      PromoBuyXGetYBuyConditionEntity entity) {
    return PromoBuyXGetYBuyConditionModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprbId: entity.toprbId,
      toitmId: entity.toitmId,
      quantity: entity.quantity,
      itemPrice: entity.itemPrice,
    );
  }
}
