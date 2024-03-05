import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_bertingkat_default_price_level.dart';

const String tablePromoBertingkatDefaultPriceLevel = "tprp8";

class PromoBertingkatDefaultPriceLevelFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprpId,
    promoType,
    minQuantity,
    promoValue,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprpId = "toprpId";
  static const String promoType = "promotype";
  static const String minQuantity = "minquantity";
  static const String promoValue = "promovalue";
}

class PromoBertingkatDefaultPriceLevelModel
    extends PromoBertingkatDefaultPriceLevelEntity implements BaseModel {
  PromoBertingkatDefaultPriceLevelModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprpId,
    required super.promoType,
    required super.minQuantity,
    required super.promoValue,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprpId': toprpId,
      'promotype': promoType,
      'minquantity': minQuantity,
      'promovalue': promoValue,
    };
  }

  factory PromoBertingkatDefaultPriceLevelModel.fromMap(
      Map<String, dynamic> map) {
    return PromoBertingkatDefaultPriceLevelModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprpId: map['toprpId'] != null ? map['toprpId'] as String : null,
      promoType: map['promotype'] as String,
      minQuantity: map['minquantity'] as double,
      promoValue: map['promovalue'] as double,
    );
  }

  factory PromoBertingkatDefaultPriceLevelModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoBertingkatDefaultPriceLevelModel.fromMap({
      ...map,
      "toprpId": map['toprp_id']?['docid'] != null
          ? map['toprp_id']['docid'] as String
          : null,
      "minquantity": map['minquantity'].toDouble() as double,
      "promovalue": map['promovalue'].toDouble() as double,
    });
  }

  factory PromoBertingkatDefaultPriceLevelModel.fromEntity(
      PromoBertingkatDefaultPriceLevelEntity entity) {
    return PromoBertingkatDefaultPriceLevelModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprpId: entity.toprpId,
      promoType: entity.promoType,
      minQuantity: entity.minQuantity,
      promoValue: entity.promoValue,
    );
  }
}
