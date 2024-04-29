import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_harga_spesial_buy.dart';

const String tablePromoHargaSpesialBuy = "tpsb1";

class PromoHargaSpesialBuyFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topsbId,
    qty,
    price,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topsbId = "topsbId";
  static const String qty = "qty";
  static const String price = "price";
}

class PromoHargaSpesialBuyModel extends PromoHargaSpesialBuyEntity
    implements BaseModel {
  PromoHargaSpesialBuyModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topsbId,
    required super.qty,
    required super.price,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'topsbId': topsbId,
      'qty': qty,
      'price': price,
    };
  }

  factory PromoHargaSpesialBuyModel.fromMap(Map<String, dynamic> map) {
    return PromoHargaSpesialBuyModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      topsbId: map['topsbId'] != null ? map['topsbId'] as String : null,
      qty: map['qty'] as double,
      price: map['price'] as double,
    );
  }

  factory PromoHargaSpesialBuyModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoHargaSpesialBuyModel.fromMap({
      ...map,
      'topsbId': map['topsbdocid'] != null ? map['topsbdocid'] as String : null,
    });
  }

  factory PromoHargaSpesialBuyModel.fromEntity(
      PromoHargaSpesialBuyEntity entity) {
    return PromoHargaSpesialBuyModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topsbId: entity.topsbId,
      qty: entity.qty,
      price: entity.price,
    );
  }
}
