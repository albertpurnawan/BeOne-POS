import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_credit_card.dart';

const String tablePromoCreditCard = "toprc";

class PromoCreditCardFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    promoCode,
    description,
    startDate,
    endDate,
    startTime,
    endTime,
    remarks,
    minPurchase,
    discPct,
    discValue,
    statusActive,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String promoCode = "promocode";
  static const String description = "description";
  static const String startDate = "startdate";
  static const String endDate = "endate";
  static const String startTime = "starttime";
  static const String endTime = "endtime";
  static const String remarks = "remarks";
  static const String minPurchase = "minpurchase";
  static const String discPct = "discpct";
  static const String discValue = "discvalue";
  static const String statusActive = "statusactive";
}

class PromoCreditCardModel extends PromoCreditCardEntity implements BaseModel {
  PromoCreditCardModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.promoCode,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.startTime,
    required super.endTime,
    required super.remarks,
    required super.minPurchase,
    required super.discPct,
    required super.discValue,
    required super.statusActive,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.toUtc().toIso8601String(),
      'updateDate': updateDate?.toUtc().toIso8601String(),
      'promoCode': promoCode,
      'description': description,
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate.toUtc().toIso8601String(),
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
      'remarks': remarks,
      'minPurchase': minPurchase,
      'discPct': discPct,
      'discValue': discValue,
      'statusActive': statusActive,
    };
  }

  factory PromoCreditCardModel.fromMap(Map<String, dynamic> map) {
    return PromoCreditCardModel(
      docId: map['docId'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updateDate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      promoCode: map['promoCode'] as String,
      description: map['description'] as String,
      startDate: DateTime.parse(map['startdate'] as String).toLocal(),
      endDate: DateTime.parse(map['enddate'] as String).toLocal(),
      startTime: DateTime.parse(map['starttime'] as String).toLocal(),
      endTime: DateTime.parse(map['endtime'] as String).toLocal(),
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      minPurchase: map['minPurchase'] as double,
      discPct: map['discPct'] as double,
      discValue: map['discValue'] as double,
      statusActive: map['statusActive'] as int,
    );
  }

  factory PromoCreditCardModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoCreditCardModel.fromMap({
      ...map,
      "minpurchase": map['minPurchase'].toDouble() as double,
      "discpct": map['discPct'].toDouble() as double,
      "discvalue": map['discValue'].toDouble() as double,
    });
  }

  factory PromoCreditCardModel.fromEntity(PromoCreditCardEntity entity) {
    return PromoCreditCardModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      promoCode: entity.promoCode,
      description: entity.description,
      startDate: entity.startDate,
      endDate: entity.endDate,
      startTime: entity.startTime,
      endTime: entity.endTime,
      remarks: entity.remarks,
      minPurchase: entity.minPurchase,
      discPct: entity.discPct,
      discValue: entity.discValue,
      statusActive: entity.statusActive,
    );
  }
}
