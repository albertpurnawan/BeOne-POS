import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_package_valid_days.dart';

const String tablePromoPackageValidDays = "tprk3";

class PromoPackageValidDaysFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tprk2Id,
    day,
    status,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tprk2Id = "tprk2Id";
  static const String day = "day";
  static const String status = "status";
}

class PromoPackageValidDaysModel extends PromoPackageValidDaysEntity
    implements BaseModel {
  PromoPackageValidDaysModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tprk2Id,
    required super.day,
    required super.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tprk2Id': tprk2Id,
      'day': day,
      'status': status,
    };
  }

  factory PromoPackageValidDaysModel.fromMap(Map<String, dynamic> map) {
    return PromoPackageValidDaysModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tprk2Id: map['tprk2Id'] != null ? map['tprk2Id'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  factory PromoPackageValidDaysModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoPackageValidDaysModel.fromMap({
      ...map,
      "tprk2Id": map['tprk2_id']?['docid'] != null
          ? map['tprk2_id']['docid'] as String
          : null,
    });
  }

  factory PromoPackageValidDaysModel.fromEntity(
      PromoPackageValidDaysEntity entity) {
    return PromoPackageValidDaysModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tprk2Id: entity.tprk2Id,
      day: entity.day,
      status: entity.status,
    );
  }
}
