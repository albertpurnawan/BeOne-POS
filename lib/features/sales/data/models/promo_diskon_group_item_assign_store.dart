import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_group_item_assign_store.dart';

const String tablePromoDiskonGroupItemAssignStore = "tpdg2";

class PromoDiskonGroupItemAssignStoreFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topdgId,
    tostrId,
    holiday,
    day1,
    day2,
    day3,
    day4,
    day5,
    day6,
    day7,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topdgId = "topdgId";
  static const String tostrId = "tostrId";
  static const String holiday = "holiday";
  static const String day1 = "day1";
  static const String day2 = "day2";
  static const String day3 = "day3";
  static const String day4 = "day4";
  static const String day5 = "day5";
  static const String day6 = "day6";
  static const String day7 = "day7";
}

class PromoDiskonGroupItemAssignStoreModel
    extends PromoDiskonGroupItemAssignStoreEntity implements BaseModel {
  PromoDiskonGroupItemAssignStoreModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topdgId,
    required super.tostrId,
    required super.holiday,
    required super.day1,
    required super.day2,
    required super.day3,
    required super.day4,
    required super.day5,
    required super.day6,
    required super.day7,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'topdgId': topdgId,
      'tostrId': tostrId,
      'holiday': holiday,
      'day1': day1,
      'day2': day2,
      'day3': day3,
      'day4': day4,
      'day5': day5,
      'day6': day6,
      'day7': day7,
    };
  }

  factory PromoDiskonGroupItemAssignStoreModel.fromMap(
      Map<String, dynamic> map) {
    return PromoDiskonGroupItemAssignStoreModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      topdgId: map['topdgId'] != null ? map['topdgId'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      holiday: map['holiday'] as int,
      day1: map['day1'] as int,
      day2: map['day2'] as int,
      day3: map['day3'] as int,
      day4: map['day4'] as int,
      day5: map['day5'] as int,
      day6: map['day6'] as int,
      day7: map['day7'] as int,
    );
  }

  factory PromoDiskonGroupItemAssignStoreModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoDiskonGroupItemAssignStoreModel.fromMap({
      ...map,
      'topdgId': map['topdgdocid'] != null ? map['topdgdocid'] as String : null,
      'tostrId': map['tostrdocid'] != null ? map['tostrdocid'] as String : null,
    });
  }

  factory PromoDiskonGroupItemAssignStoreModel.fromEntity(
      PromoDiskonGroupItemAssignStoreEntity entity) {
    return PromoDiskonGroupItemAssignStoreModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topdgId: entity.topdgId,
      tostrId: entity.tostrId,
      holiday: entity.holiday,
      day1: entity.day1,
      day2: entity.day2,
      day3: entity.day3,
      day4: entity.day4,
      day5: entity.day5,
      day6: entity.day6,
      day7: entity.day7,
    );
  }
}
