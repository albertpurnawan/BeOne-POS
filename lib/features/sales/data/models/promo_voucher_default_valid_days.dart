import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_voucher_default_valid_days.dart';

const String tablePromoVoucherDefaultValidDays = "tprr9";

class PromoVoucherDefaultValidDaysFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprrId,
    day,
    status,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprrId = "toprrId";
  static const String day = "day";
  static const String status = "status";
}

class PromoVoucherDefaultValidDaysModel
    extends PromoVoucherDefaultValidDaysEntity implements BaseModel {
  PromoVoucherDefaultValidDaysModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprrId,
    required super.day,
    required super.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprrId': toprrId,
      'day': day,
      'status': status,
    };
  }

  factory PromoVoucherDefaultValidDaysModel.fromMap(Map<String, dynamic> map) {
    return PromoVoucherDefaultValidDaysModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprrId: map['toprrId'] != null ? map['toprrId'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  factory PromoVoucherDefaultValidDaysModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoVoucherDefaultValidDaysModel.fromMap({
      ...map,
      "toprrId": map['toprr_id']?['docid'] != null
          ? map['toprr_id']['docid'] as String
          : null,
    });
  }

  factory PromoVoucherDefaultValidDaysModel.fromEntity(
      PromoVoucherDefaultValidDaysEntity entity) {
    return PromoVoucherDefaultValidDaysModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprrId: entity.toprrId,
      day: entity.day,
      status: entity.status,
    );
  }
}
