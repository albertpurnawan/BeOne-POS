import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_group_item_get_condition.dart';

const String tablePromoDiskonGroupItemGetCondition = "tpdg4";

class PromoDiskonGroupItemGetConditionFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topdgId,
    promoValue,
    discount1,
    discount2,
    discount3,
    form,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topdgId = "topdgId";
  static const String promoValue = "promovalue";
  static const String discount1 = "discount1";
  static const String discount2 = "discount2";
  static const String discount3 = "discount3";
  static const String form = "form";
}

class PromoDiskonGroupItemGetConditionModel
    extends PromoDiskonGroupItemGetConditionEntity implements BaseModel {
  PromoDiskonGroupItemGetConditionModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topdgId,
    required super.promoValue,
    required super.discount1,
    required super.discount2,
    required super.discount3,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'topdgId': topdgId,
      'promovalue': promoValue,
      'discount1': discount1,
      'discount2': discount2,
      'discount3': discount3,
      'form': form,
    };
  }

  factory PromoDiskonGroupItemGetConditionModel.fromMap(
      Map<String, dynamic> map) {
    return PromoDiskonGroupItemGetConditionModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      topdgId: map['topdgId'] != null ? map['topdgId'] as String : null,
      promoValue: map['promovalue'] as double,
      discount1: map['discount1'] as double,
      discount2: map['discount2'] as double,
      discount3: map['discount3'] as double,
      form: map['form'] as String,
    );
  }

  factory PromoDiskonGroupItemGetConditionModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoDiskonGroupItemGetConditionModel.fromMap({
      ...map,
      'topdgId': map['topdgdocid'] != null ? map['topdgdocid'] as String : null,
      'promovalue': double.tryParse(map['promovalue'].toString()),
      'discount1': double.tryParse(map['discount1'].toString()),
      'discount2': double.tryParse(map['discount2'].toString()),
      'discount3': double.tryParse(map['discount3'].toString()),
    });
  }

  factory PromoDiskonGroupItemGetConditionModel.fromEntity(
      PromoDiskonGroupItemGetConditionEntity entity) {
    return PromoDiskonGroupItemGetConditionModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topdgId: entity.topdgId,
      promoValue: entity.promoValue,
      discount1: entity.discount1,
      discount2: entity.discount2,
      discount3: entity.discount3,
      form: entity.form,
    );
  }
}
