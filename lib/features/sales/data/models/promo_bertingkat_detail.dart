import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_bertingkat_detail.dart';

const String tablePromoBertingkatDetail = "tprp1";

class PromoBertingkatDetailFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprpId,
    toitmId,
    promoType,
    minQuantity,
    promoValue,
    itemPrice,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprpId = "toprpId";
  static const String toitmId = "toitmId";
  static const String promoType = "promotype";
  static const String minQuantity = "minquantity";
  static const String promoValue = "promovalue";
  static const String itemPrice = "itemprice";
}

class PromoBertingkatDetailModel extends PromoBertingkatDetailEntity
    implements BaseModel {
  PromoBertingkatDetailModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprpId,
    required super.toitmId,
    required super.promoType,
    required super.minQuantity,
    required super.promoValue,
    required super.itemPrice,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprpId': toprpId,
      'toitmId': toitmId,
      'promotype': promoType,
      'minquantity': minQuantity,
      'promovalue': promoValue,
      'itemprice': itemPrice,
    };
  }

  factory PromoBertingkatDetailModel.fromMap(Map<String, dynamic> map) {
    return PromoBertingkatDetailModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprpId: map['toprpId'] != null ? map['toprpId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      promoType: map['promotype'] as String,
      minQuantity: map['minquantity'] as double,
      promoValue: map['promovalue'] as double,
      itemPrice: map['itemprice'] != null ? map['itemPrice'] as double : null,
    );
  }

  factory PromoBertingkatDetailModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoBertingkatDetailModel.fromMap({
      ...map,
      "toprpId": map['toprp_id']?['docid'] != null
          ? map['toprp_id']['docid'] as String
          : null,
      "toitmId": map['toitm_id']?['docid'] != null
          ? map['toitm_id']['docid'] as String
          : null,
      "minquantity": map['minquantity'].toDouble() as double,
      "promovalue": map['promovalue'].toDouble() as double,
    });
  }

  factory PromoBertingkatDetailModel.fromEntity(
      PromoBertingkatDetailEntity entity) {
    return PromoBertingkatDetailModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprpId: entity.toprpId,
      toitmId: entity.toitmId,
      promoType: entity.promoType,
      minQuantity: entity.minQuantity,
      promoValue: entity.promoValue,
      itemPrice: entity.itemPrice,
    );
  }
}
