import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_get_condition.dart';

const String tablePromoBuyXGetYGetCondition = "tprb4";

class PromoBuyXGetYGetConditionFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprbId,
    toitmId,
    quantity,
    sellingPrice,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprbId = "toprbId";
  static const String toitmId = "toitmId";
  static const String quantity = "quantity";
  static const String sellingPrice = "sellingprice";
}

class PromoBuyXGetYGetConditionModel extends PromoBuyXGetYGetConditionEntity
    implements BaseModel {
  PromoBuyXGetYGetConditionModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprbId,
    required super.toitmId,
    required super.quantity,
    required super.sellingPrice,
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
      'sellingprice': sellingPrice,
    };
  }

  factory PromoBuyXGetYGetConditionModel.fromMap(Map<String, dynamic> map) {
    return PromoBuyXGetYGetConditionModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprbId: map['toprbId'] != null ? map['toprbId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      sellingPrice: map['sellingprice'] as double,
    );
  }

  factory PromoBuyXGetYGetConditionModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoBuyXGetYGetConditionModel.fromMap({
      ...map,
      "toprbId": map['toprb_id']?['docid'] != null
          ? map['toprb_id']['docid'] as String
          : null,
      "toitmId": map['toitm_id']?['docid'] != null
          ? map['toitm_id']['docid'] as String
          : null,
    });
  }

  factory PromoBuyXGetYGetConditionModel.fromEntity(
      PromoBuyXGetYGetConditionEntity entity) {
    return PromoBuyXGetYGetConditionModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprbId: entity.toprbId,
      toitmId: entity.toitmId,
      quantity: entity.quantity,
      sellingPrice: entity.sellingPrice,
    );
  }
}
