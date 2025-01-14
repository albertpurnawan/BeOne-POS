import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';

const String tablePromotions = "toprm";

class PromotionsFields {
  static const List<String> values = [
    docId,
    toitmId,
    promoType,
    promoId,
    date,
    startTime,
    endTime,
    tocrgId,
    promoDescription,
    tocatId,
    remarks,
  ];
  static const String docId = "docid";
  static const String toitmId = "toitmId";
  static const String promoType = "promotype";
  static const String promoId = "promoId";
  static const String date = "date";
  static const String startTime = "starttime";
  static const String endTime = "endtime";
  static const String tocrgId = "tocrgId";
  static const String promoDescription = "promodescription";
  static const String tocatId = "tocatId";
  static const String remarks = "remarks";
}

class PromotionsModel extends PromotionsEntity implements BaseModel {
  PromotionsModel({
    required super.docId,
    required super.toitmId,
    required super.promoType,
    required super.promoId,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.tocrgId,
    required super.promoDescription,
    required super.tocatId,
    required super.remarks,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'toitmId': toitmId,
      'promotype': promoType,
      'promoId': promoId,
      'date': date.toUtc().toIso8601String(),
      'starttime': startTime.toUtc().toIso8601String(),
      'endtime': endTime.toUtc().toIso8601String(),
      'tocrgId': tocrgId,
      'promodescription': promoDescription,
      'tocatId': tocatId,
      'remarks': remarks,
    };
  }

  factory PromotionsModel.fromMap(Map<String, dynamic> map) {
    return PromotionsModel(
      docId: map['docid'] as String,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      promoType: map['promotype'] as int,
      promoId: map['promoId'] != null ? map['promoId'] as String : null,
      date: DateTime.parse(map['date'] as String),
      startTime: DateTime.parse(map['starttime'] as String),
      endTime: DateTime.parse(map['endtime'] as String),
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
      promoDescription: map['promodescription'] as String,
      tocatId: map['tocatId'] != null ? map['tocatId'] as String : null,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
    );
  }

  factory PromotionsModel.fromEntity(PromotionsEntity entity) {
    return PromotionsModel(
      docId: entity.docId,
      toitmId: entity.toitmId,
      promoType: entity.promoType,
      promoId: entity.promoId,
      date: entity.date,
      startTime: entity.startTime,
      endTime: entity.endTime,
      tocrgId: entity.tocrgId,
      promoDescription: entity.promoDescription,
      tocatId: entity.tocatId,
      remarks: entity.remarks,
    );
  }
}
