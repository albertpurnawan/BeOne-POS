import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';

const String tablePromotions = "toprm";

class PromotionsFields {
  static const List<String> values = [
    toitmId,
    promoType,
    promoId,
    date,
    startTime,
    endTime,
    tocrgId,
    promoDescription,
    tocatId,
  ];
  static const String toitmId = "toitmId";
  static const String promoType = "promotype";
  static const String promoId = "promoId";
  static const String date = "date";
  static const String startTime = "starttime";
  static const String endTime = "endtime";
  static const String tocrgId = "tocrgId";
  static const String promoDescription = "promodescription";
  static const String tocatId = "tocatId";
}

class PromotionsModel extends PromotionsEntity implements BaseModel {
  PromotionsModel({
    required super.toitmId,
    required super.promoType,
    required super.promoId,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.tocrgId,
    required super.promoDescription,
    required super.tocatId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'toitmId': toitmId,
      'promotype': promoType,
      'promoId': promoId,
      'date': date.toUtc().toIso8601String(),
      'starttime': startTime.toUtc().toIso8601String(),
      'endtime': endTime.toUtc().toIso8601String(),
      'tocrgId': tocrgId,
      'promodescription': promoDescription,
      'tocatId': tocatId,
    };
  }

  factory PromotionsModel.fromMap(Map<String, dynamic> map) {
    return PromotionsModel(
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      promoType: map['promotype'] as int,
      promoId: map['promoId'] != null ? map['promoId'] as String : null,
      date: DateTime.parse(map['date'] as String).toLocal(),
      startTime: DateTime.parse(map['starttime'] as String).toLocal(),
      endTime: DateTime.parse(map['endtime'] as String).toLocal(),
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
      promoDescription: map['promodescription'] as String,
      tocatId: map['tocatId'] != null ? map['tocatId'] as String : null,
    );
  }

  factory PromotionsModel.fromEntity(PromotionsEntity entity) {
    return PromotionsModel(
      toitmId: entity.toitmId,
      promoType: entity.promoType,
      promoId: entity.promoId,
      date: entity.date,
      startTime: entity.startTime,
      endTime: entity.endTime,
      tocrgId: entity.tocrgId,
      promoDescription: entity.promoDescription,
      tocatId: entity.tocatId,
    );
  }
}
