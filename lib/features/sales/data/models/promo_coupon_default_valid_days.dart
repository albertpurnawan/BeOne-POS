import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_default_valid_days.dart';

const String tablePromoCouponDefaultValidDays = "tprn9";

class PromoCouponDefaultValidDaysFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprnId,
    day,
    status,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprnId = "toprnId";
  static const String day = "day";
  static const String status = "status";
}

class PromoCouponDefaultValidDaysModel extends PromoCouponDefaultValidDaysEntity
    implements BaseModel {
  PromoCouponDefaultValidDaysModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprnId,
    required super.day,
    required super.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprnId': toprnId,
      'day': day,
      'status': status,
    };
  }

  factory PromoCouponDefaultValidDaysModel.fromMap(Map<String, dynamic> map) {
    return PromoCouponDefaultValidDaysModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprnId: map['toprnId'] != null ? map['toprnId'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  factory PromoCouponDefaultValidDaysModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoCouponDefaultValidDaysModel.fromMap({
      ...map,
      "toprnId": map['toprn_id']?['docid'] != null
          ? map['toprn_id']['docid'] as String
          : null,
    });
  }

  factory PromoCouponDefaultValidDaysModel.fromEntity(
      PromoCouponDefaultValidDaysEntity entity) {
    return PromoCouponDefaultValidDaysModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprnId: entity.toprnId,
      day: entity.day,
      status: entity.status,
    );
  }
}
