import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_gwp_detail.dart';

const String tablePromoGWPDetail = "tprg1";

class PromoGWPDetailFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprgId,
    toitmId,
    quantity,
    sellingPrice,
    itemPrice,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprgId = "toprgId";
  static const String toitmId = "toitmId";
  static const String quantity = "quantity";
  static const String sellingPrice = "sellingprice";
  static const String itemPrice = "itemprice";
}

class PromoGWPDetailModel extends PromoGWPDetailEntity implements BaseModel {
  PromoGWPDetailModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprgId,
    required super.toitmId,
    required super.quantity,
    required super.sellingPrice,
    required super.itemPrice,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprgId': toprgId,
      'toitmId': toitmId,
      'quantity': quantity,
      'sellingprice': sellingPrice,
      'itemprice': itemPrice,
    };
  }

  factory PromoGWPDetailModel.fromMap(Map<String, dynamic> map) {
    return PromoGWPDetailModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprgId: map['toprgId'] != null ? map['toprgId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      sellingPrice: map['sellingprice'] as double,
      itemPrice: map['itemprice'] != null ? map['itemprice'] as double : null,
    );
  }

  factory PromoGWPDetailModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoGWPDetailModel.fromMap({
      ...map,
      "toprgId": map['toprg_id']?['docid'] != null
          ? map['toprg_id']['docid'] as String
          : null,
      "toitmId": map['toitm_id']?['docid'] != null
          ? map['toitm_id']['docid'] as String
          : null,
      "quantity": map['quantity'].toDouble() as double,
      "sellingprice": map['sellingprice'].toDouble() as double,
      "itemprice": map['itemprice'] != null
          ? map['itemprice'].toDouble() as double
          : null,
    });
  }

  factory PromoGWPDetailModel.fromEntity(PromoGWPDetailEntity entity) {
    return PromoGWPDetailModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprgId: entity.toprgId,
      toitmId: entity.toitmId,
      quantity: entity.quantity,
      sellingPrice: entity.sellingPrice,
      itemPrice: entity.itemPrice,
    );
  }
}
