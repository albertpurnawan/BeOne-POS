import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_spesial_multi_item_assign_store.dart';

const String tablePromoSpesialMultiItemAssignStore = "tpsm2";

class PromoSpesialMultiItemAssignStoreFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topsmId,
    tostrId,
    holiday,
    day1,
    day2,
    day3,
    day4,
    day5,
    day6,
    day7,
    form,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topsmId = "topsmId";
  static const String tostrId = "tostrId";
  static const String holiday = "holiday";
  static const String day1 = "day1";
  static const String day2 = "day2";
  static const String day3 = "day3";
  static const String day4 = "day4";
  static const String day5 = "day5";
  static const String day6 = "day6";
  static const String day7 = "day7";
  static const String form = "form";
}

class PromoSpesialMultiItemAssignStoreModel extends PromoSpesialMultiItemAssignStoreEntity implements BaseModel {
  PromoSpesialMultiItemAssignStoreModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topsmId,
    required super.tostrId,
    required super.holiday,
    required super.day1,
    required super.day2,
    required super.day3,
    required super.day4,
    required super.day5,
    required super.day6,
    required super.day7,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'topsmId': topsmId,
      'tostrId': tostrId,
      'holiday': holiday,
      'day1': day1,
      'day2': day2,
      'day3': day3,
      'day4': day4,
      'day5': day5,
      'day6': day6,
      'day7': day7,
      'form': form,
    };
  }

  factory PromoSpesialMultiItemAssignStoreModel.fromMap(Map<String, dynamic> map) {
    return PromoSpesialMultiItemAssignStoreModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate'] as String).toLocal() : null,
      topsmId: map['topsmId'] != null ? map['topsmId'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      holiday: map['holiday'] as int,
      day1: map['day1'] as int,
      day2: map['day2'] as int,
      day3: map['day3'] as int,
      day4: map['day4'] as int,
      day5: map['day5'] as int,
      day6: map['day6'] as int,
      day7: map['day7'] as int,
      form: map['form'] as String,
    );
  }

  factory PromoSpesialMultiItemAssignStoreModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoSpesialMultiItemAssignStoreModel.fromMap({
      ...map,
      'topsmId': map['topsmdocid'] != null ? map['topsmdocid'] as String : null,
      'tostrId': map['tostrdocid'] != null ? map['tostrdocid'] as String : null,
    });
  }

  factory PromoSpesialMultiItemAssignStoreModel.fromEntity(PromoSpesialMultiItemAssignStoreEntity entity) {
    return PromoSpesialMultiItemAssignStoreModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topsmId: entity.topsmId,
      tostrId: entity.tostrId,
      holiday: entity.holiday,
      day1: entity.day1,
      day2: entity.day2,
      day3: entity.day3,
      day4: entity.day4,
      day5: entity.day5,
      day6: entity.day6,
      day7: entity.day7,
      form: entity.form,
    );
  }
}
