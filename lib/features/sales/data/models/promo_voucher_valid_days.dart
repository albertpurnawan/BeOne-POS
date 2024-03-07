import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_voucher_valid_days.dart';

const String tablePromoVoucherValidDays = "tprr3";

class PromoVoucherValidDaysFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tprr2Id,
    day,
    status,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tprr2Id = "tprr2id";
  static const String day = "day";
  static const String status = "status";
}

class PromoVoucherValidDaysModel extends PromoVoucherValidDaysEntity
    implements BaseModel {
  PromoVoucherValidDaysModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tprr2Id,
    required super.day,
    required super.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tprr2Id': tprr2Id,
      'day': day,
      'status': status,
    };
  }

  factory PromoVoucherValidDaysModel.fromMap(Map<String, dynamic> map) {
    return PromoVoucherValidDaysModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tprr2Id: map['tprr2Id'] != null ? map['tprr2Id'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  factory PromoVoucherValidDaysModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoVoucherValidDaysModel.fromMap({
      ...map,
      "tprr2Id": map['tprr2_id']?['docid'] != null
          ? map['tprr2_id']['docid'] as String
          : null,
    });
  }

  factory PromoVoucherValidDaysModel.fromEntity(
      PromoVoucherValidDaysEntity entity) {
    return PromoVoucherValidDaysModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tprr2Id: entity.tprr2Id,
      day: entity.day,
      status: entity.status,
    );
  }
}
