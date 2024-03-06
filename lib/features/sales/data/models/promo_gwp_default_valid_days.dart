import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_gwp_default_valid_days.dart';

const String tablePromoGWPDefaultValidDays = "tprg9";

class PromoGWPDefaultValidDaysFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprgId,
    day,
    status,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprgId = "toprgId";
  static const String day = "day";
  static const String status = "status";
}

class PromoGWPDefaultValidDaysModel extends PromoGWPDefaultValidDaysEntity
    implements BaseModel {
  PromoGWPDefaultValidDaysModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprgId,
    required super.day,
    required super.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprgId': toprgId,
      'day': day,
      'status': status,
    };
  }

  factory PromoGWPDefaultValidDaysModel.fromMap(Map<String, dynamic> map) {
    return PromoGWPDefaultValidDaysModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprgId: map['toprgId'] as String,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  factory PromoGWPDefaultValidDaysModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoGWPDefaultValidDaysModel.fromMap({
      ...map,
      "toprgId": map['toprg_id']?['docid'] != null
          ? map['toprg_id']['docid'] as String
          : null,
    });
  }

  factory PromoGWPDefaultValidDaysModel.fromEntity(
      PromoGWPDefaultValidDaysEntity entity) {
    return PromoGWPDefaultValidDaysModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprgId: entity.toprgId,
      day: entity.day,
      status: entity.status,
    );
  }
}
