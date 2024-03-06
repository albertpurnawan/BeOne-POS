import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_package_buy.dart';

const String tablePromoPackageBuy = "tprk1";

class PromoPackageBuyFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprkId,
    toitmId,
    minQuantity,
    itemPrice,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprkId = "toprkId";
  static const String toitmId = "toitmId";
  static const String minQuantity = "minquantity";
  static const String itemPrice = "itemprice";
}

class PromoPackageBuyModel extends PromoPackageBuyEntity implements BaseModel {
  PromoPackageBuyModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprkId,
    required super.toitmId,
    required super.minQuantity,
    required super.itemPrice,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprkId': toprkId,
      'toitmId': toitmId,
      'minquantity': minQuantity,
      'itemprice': itemPrice,
    };
  }

  factory PromoPackageBuyModel.fromMap(Map<String, dynamic> map) {
    return PromoPackageBuyModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprkId: map['toprkId'] != null ? map['toprkId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      minQuantity: map['minquantity'] as double,
      itemPrice: map['itemprice'] != null ? map['itemprice'] as double : null,
    );
  }

  factory PromoPackageBuyModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoPackageBuyModel.fromMap({
      ...map,
      "toprkId": map['toprk_id']?['docid'] != null
          ? map['toprk_id']['docid'] as String
          : null,
      "toitmId": map['toitm_id']?['docid'] != null
          ? map['toitm_id']['docid'] as String
          : null,
      "minquantity": map['minquantity'] as double,
      "itemprice": map['itemprice'] != null ? map['itemprice'] as double : null,
    });
  }

  factory PromoPackageBuyModel.fromEntity(PromoPackageBuyEntity entity) {
    return PromoPackageBuyModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprkId: entity.toprkId,
      toitmId: entity.toitmId,
      minQuantity: entity.minQuantity,
      itemPrice: entity.itemPrice,
    );
  }
}
