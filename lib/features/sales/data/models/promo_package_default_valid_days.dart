import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_package_default_valid_days.dart';

const String tablePromoPackageDefaultValidDays = "tprk9";

class PromoPackageDefaultValidDaysFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprkId,
    day,
    status,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprkId = "toprkId";
  static const String day = "day";
  static const String status = "status";
}

class PromoPackageDefaultValidDaysModel
    extends PromoPackageDefaultValidDaysEntity implements BaseModel {
  PromoPackageDefaultValidDaysModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprkId,
    required super.day,
    required super.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprkId': toprkId,
      'day': day,
      'status': status,
    };
  }

  factory PromoPackageDefaultValidDaysModel.fromMap(Map<String, dynamic> map) {
    return PromoPackageDefaultValidDaysModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprkId: map['toprkId'] != null ? map['toprkId'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  factory PromoPackageDefaultValidDaysModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoPackageDefaultValidDaysModel.fromMap({
      ...map,
      "toprkId": map['toprk_id']?['docid'] != null
          ? map['toprk_id']['docid'] as String
          : null,
    });
  }

  factory PromoPackageDefaultValidDaysModel.fromEntity(
      PromoPackageDefaultValidDaysEntity entity) {
    return PromoPackageDefaultValidDaysModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprkId: entity.toprkId,
      day: entity.day,
      status: entity.status,
    );
  }
}
