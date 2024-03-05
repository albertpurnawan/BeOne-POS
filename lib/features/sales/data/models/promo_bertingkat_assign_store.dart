import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_bertingkat_assign_store.dart';

const String tablePromoBertingkatAssignStore = "tprp2";

class PromoBertingkatAssignStoreFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprpId,
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
  static const String toprpId = "toprpId";
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

class PromoBertingkatAssignStoreModel extends PromoBertingkatAssignStoreEntity
    implements BaseModel {
  PromoBertingkatAssignStoreModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprpId,
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
      'docId': docId,
      'createDate': createDate.toUtc().toIso8601String(),
      'updateDate': updateDate?.toUtc().toIso8601String(),
      'toprpId': toprpId,
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

  factory PromoBertingkatAssignStoreModel.fromMap(Map<String, dynamic> map) {
    return PromoBertingkatAssignStoreModel(
      docId: map['docId'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updateDate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprpId: map['toprpId'] != null ? map['toprpId'] as String : null,
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

  factory PromoBertingkatAssignStoreModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoBertingkatAssignStoreModel.fromMap({
      ...map,
      "toprpId": map['toprp_id']?['docid'] != null
          ? map['toprp_id']['docid'] as String
          : null,
      "tostrId": map['tostr_id']?['docid'] != null
          ? map['tostr_id']['docid'] as String
          : null,
    });
  }

  factory PromoBertingkatAssignStoreModel.fromEntity(
      PromoBertingkatAssignStoreEntity entity) {
    return PromoBertingkatAssignStoreModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprpId: entity.toprpId,
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
