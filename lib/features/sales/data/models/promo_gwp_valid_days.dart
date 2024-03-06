import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_gwp_valid_days.dart';

const String tablePromoGWPValidDays = "tprg3";

class PromoGWPValidDaysFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tprg2Id,
    day,
    status,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tprg2Id = "tprg2Id";
  static const String day = "day";
  static const String status = "status";
}

class PromoGWPValidDaysModel extends PromoGWPValidDaysEntity
    implements BaseModel {
  PromoGWPValidDaysModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tprg2Id,
    required super.day,
    required super.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tprg2Id': tprg2Id,
      'day': day,
      'status': status,
    };
  }

  factory PromoGWPValidDaysModel.fromMap(Map<String, dynamic> map) {
    return PromoGWPValidDaysModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tprg2Id: map['tprg2Id'] != null ? map['tprg2Id'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  factory PromoGWPValidDaysModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoGWPValidDaysModel.fromMap({
      ...map,
      "tprg2Id": map['tprg2_id']?['docid'] != null
          ? map['tprg2_id']['docid'] as String
          : null,
    });
  }

  factory PromoGWPValidDaysModel.fromEntity(PromoGWPValidDaysEntity entity) {
    return PromoGWPValidDaysModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tprg2Id: entity.tprg2Id,
      day: entity.day,
      status: entity.status,
    );
  }
}
