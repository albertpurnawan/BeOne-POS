import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_spesial_multi_item_detail.dart';

const String tablePromoSpesialMultiItemDetail = "tpsm1";

class PromoSpesialMultiItemDetailFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topsmId,
    toitmId,
    qtyFrom,
    qtyTo,
    price,
    form,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topsmId = "topsmId";
  static const String toitmId = "toitmId";
  static const String qtyFrom = "qtyfrom";
  static const String qtyTo = "qtyto";
  static const String price = "price";
  static const String form = "form";
}

class PromoSpesialMultiItemDetailModel extends PromoSpesialMultiItemDetailEntity implements BaseModel {
  PromoSpesialMultiItemDetailModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topsmId,
    required super.toitmId,
    required super.qtyFrom,
    required super.qtyTo,
    required super.price,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'topsmId': topsmId,
      'toitmId': toitmId,
      'qtyfrom': qtyFrom,
      'qtyto': qtyTo,
      'price': price,
      'form': form,
    };
  }

  factory PromoSpesialMultiItemDetailModel.fromMap(Map<String, dynamic> map) {
    return PromoSpesialMultiItemDetailModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate'] as String).toLocal() : null,
      topsmId: map['topsmId'] != null ? map['topsmId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      qtyFrom: map['qtyfrom'] as double,
      qtyTo: map['qtyto'] as double,
      price: map['price'] as double,
      form: map['form'] as String,
    );
  }

  factory PromoSpesialMultiItemDetailModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoSpesialMultiItemDetailModel.fromMap({
      ...map,
      'topsmId': map['topsbdocid'] != null ? map['topsbdocid'] as String : null,
      'toitmId': map['toitmdocid'] != null ? map['toitmdocid'] as String : null,
      'qtyfrom': double.tryParse(map['qtyfrom'].toString()) ?? 0,
      'qtyto': double.tryParse(map['qtyto'].toString()) ?? 0,
      'price': double.tryParse(map['price'].toString()) ?? 0,
    });
  }

  factory PromoSpesialMultiItemDetailModel.fromEntity(PromoSpesialMultiItemDetailEntity entity) {
    return PromoSpesialMultiItemDetailModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topsmId: entity.topsmId,
      toitmId: entity.toitmId,
      qtyFrom: entity.qtyFrom,
      qtyTo: entity.qtyTo,
      price: entity.price,
      form: entity.form,
    );
  }
}
