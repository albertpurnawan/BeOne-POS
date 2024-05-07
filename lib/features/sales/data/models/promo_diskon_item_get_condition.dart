import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_item_get_condition.dart';

const String tablePromoDiskonItemGetCondition = "tpdi4";

class PromoDiskonItemGetConditionFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topdiId,
    promoValue,
    discount1,
    discount2,
    discount3,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topdiId = "topdiId";
  static const String promoValue = "promovalue";
  static const String discount1 = "discount1";
  static const String discount2 = "discount2";
  static const String discount3 = "discount3";
}

class PromoDiskonItemGetConditionModel extends PromoDiskonItemGetConditionEntity
    implements BaseModel {
  PromoDiskonItemGetConditionModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topdiId,
    required super.promoValue,
    required super.discount1,
    required super.discount2,
    required super.discount3,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'topdiId': topdiId,
      'promovalue': promoValue,
      'discount1': discount1,
      'discount2': discount2,
      'discount3': discount3,
    };
  }

  factory PromoDiskonItemGetConditionModel.fromMap(Map<String, dynamic> map) {
    return PromoDiskonItemGetConditionModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      topdiId: map['topdiId'] != null ? map['topdiId'] as String : null,
      promoValue: map['promovalue'] as double,
      discount1: map['discount1'] as double,
      discount2: map['discount2'] as double,
      discount3: map['discount3'] as double,
    );
  }

  factory PromoDiskonItemGetConditionModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoDiskonItemGetConditionModel.fromMap({
      ...map,
      'topdiId': map['topdidocid'] != null ? map['topdidocid'] as String : null,
      'promovalue': double.tryParse(map['promovalue'].toString()),
      'discount1': double.tryParse(map['discount1'].toString()),
      'discount2': double.tryParse(map['discount2'].toString()),
      'discount3': double.tryParse(map['discount3'].toString()),
    });
  }

  factory PromoDiskonItemGetConditionModel.fromEntity(
      PromoDiskonItemGetConditionEntity entity) {
    return PromoDiskonItemGetConditionModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topdiId: entity.topdiId,
      promoValue: entity.promoValue,
      discount1: entity.discount1,
      discount2: entity.discount2,
      discount3: entity.discount3,
    );
  }
}
