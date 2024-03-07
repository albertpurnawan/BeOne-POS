import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_default_valid_days.dart';

const String tablePromoBuyXGetYDefaultValidDays = "tprb9";

class PromoBuyXGetYDefaultValidDaysFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprbId,
    day,
    status,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprbId = "toprbId";
  static const String day = "day";
  static const String status = "status";
}

class PromoBuyXGetYDefaultValidDaysModel
    extends PromoBuyXGetYDefaultValidDaysEntity implements BaseModel {
  PromoBuyXGetYDefaultValidDaysModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprbId,
    required super.day,
    required super.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.toUtc().toIso8601String(),
      'updateDate': updateDate?.toUtc().toIso8601String(),
      'toprbId': toprbId,
      'day': day,
      'status': status,
    };
  }

  factory PromoBuyXGetYDefaultValidDaysModel.fromMap(Map<String, dynamic> map) {
    return PromoBuyXGetYDefaultValidDaysModel(
      docId: map['docId'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updateDate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprbId: map['toprbId'] != null ? map['toprbId'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  factory PromoBuyXGetYDefaultValidDaysModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoBuyXGetYDefaultValidDaysModel.fromMap({
      ...map,
      "toprbId": map['toprb_id']?['docid'] != null
          ? map['toprb_id']['docid'] as String
          : null,
    });
  }

  factory PromoBuyXGetYDefaultValidDaysModel.fromEntity(
      PromoBuyXGetYDefaultValidDaysEntity entity) {
    return PromoBuyXGetYDefaultValidDaysModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprbId: entity.toprbId,
      day: entity.day,
      status: entity.status,
    );
  }
}
