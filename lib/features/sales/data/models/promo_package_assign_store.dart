import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_package_assign_store.dart';

const String tablePromoPackageAssignStore = "tprk2";

class PromoPackageAssignStoreFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprkId,
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
  static const String toprkId = "toprkId";
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

class PromoPackageAssignStoreModel extends PromoPackageAssignStoreEntity
    implements BaseModel {
  PromoPackageAssignStoreModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprkId,
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
      'toprkId': toprkId,
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

  factory PromoPackageAssignStoreModel.fromMap(Map<String, dynamic> map) {
    return PromoPackageAssignStoreModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprkId: map['toprkId'] != null ? map['toprkId'] as String : null,
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

  factory PromoPackageAssignStoreModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoPackageAssignStoreModel.fromMap({
      ...map,
      "toprkId": map['toprk_id']?['docid'] != null
          ? map['toprk_id']['docid'] as String
          : null,
      "tostrId": map['tostr_id']?['docid'] != null
          ? map['tostr_id']['docid'] as String
          : null,
    });
  }

  factory PromoPackageAssignStoreModel.fromEntity(
      PromoPackageAssignStoreEntity entity) {
    return PromoPackageAssignStoreModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprkId: entity.toprkId,
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
