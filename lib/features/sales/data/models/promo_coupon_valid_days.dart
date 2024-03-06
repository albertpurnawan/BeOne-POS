import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_valid_days.dart';

const String tablePromoCouponValidDays = "tprn3";

class PromoCouponValidDaysFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tprn2Id,
    day,
    status,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tprn2Id = "tprn2Id";
  static const String day = "day";
  static const String status = "status";
}

class PromoCouponValidDaysModel extends PromoCouponValidDaysEntity
    implements BaseModel {
  PromoCouponValidDaysModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tprn2Id,
    required super.day,
    required super.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tprn2Id': tprn2Id,
      'day': day,
      'status': status,
    };
  }

  factory PromoCouponValidDaysModel.fromMap(Map<String, dynamic> map) {
    return PromoCouponValidDaysModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tprn2Id: map['tprn2Id'] != null ? map['tprn2Id'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  factory PromoCouponValidDaysModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoCouponValidDaysModel.fromMap({
      ...map,
      "tprn2Id": map['tprn2_id']?['docid'] != null
          ? map['tprn2_id']['docid'] as String
          : null,
    });
  }

  factory PromoCouponValidDaysModel.fromEntity(
      PromoCouponValidDaysEntity entity) {
    return PromoCouponValidDaysModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tprn2Id: entity.tprn2Id,
      day: entity.day,
      status: entity.status,
    );
  }
}
