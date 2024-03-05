import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_header.dart';

const String tablePromoBuyXGetYHeader = "toprb";

class PromoBuyXGetYHeaderFields {
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
    buyCondition,
    minBuy,
    maxMultiply,
    getCondition,
    maxGet,
    statusActive,
    toplnId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String promoCode = "promocode";
  static const String description = "description";
  static const String startDate = "startdate";
  static const String endDate = "enddate";
  static const String startTime = "starttime";
  static const String endTime = "endtime";
  static const String remarks = "remarks";
  static const String minPurchase = "minpurchase";
  static const String buyCondition = "buycondition";
  static const String minBuy = "minbuy";
  static const String maxMultiply = "maxmultiply";
  static const String getCondition = "getcondition";
  static const String maxGet = "maxget";
  static const String statusActive = "statusactive";
  static const String toplnId = "toplnId";
}

class PromoBuyXGetYHeaderModel extends PromoBuyXGetYHeaderEntity
    implements BaseModel {
  PromoBuyXGetYHeaderModel({
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
    required super.buyCondition,
    required super.minBuy,
    required super.maxMultiply,
    required super.getCondition,
    required super.maxGet,
    required super.statusActive,
    required super.toplnId,
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
      'buyCondition': buyCondition,
      'minBuy': minBuy,
      'maxMultiply': maxMultiply,
      'getCondition': getCondition,
      'maxGet': maxGet,
      'statusActive': statusActive,
      'toplnId': toplnId,
    };
  }

  factory PromoBuyXGetYHeaderModel.fromMap(Map<String, dynamic> map) {
    return PromoBuyXGetYHeaderModel(
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
      buyCondition: map['buyCondition'] as int,
      minBuy: map['minBuy'] as double,
      maxMultiply: map['maxMultiply'] as double,
      getCondition: map['getCondition'] as int,
      maxGet: map['maxGet'] as double,
      statusActive: map['statusActive'] as int,
      toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
    );
  }

  factory PromoBuyXGetYHeaderModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoBuyXGetYHeaderModel.fromMap({
      ...map,
      "toplnId": map['topln_id']?['docid'] != null
          ? map['topln_id']['docid'] as String
          : null,
    });
  }

  factory PromoBuyXGetYHeaderModel.fromEntity(
      PromoBuyXGetYHeaderEntity entity) {
    return PromoBuyXGetYHeaderModel(
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
      buyCondition: entity.buyCondition,
      minBuy: entity.minBuy,
      maxMultiply: entity.maxMultiply,
      getCondition: entity.getCondition,
      maxGet: entity.maxGet,
      statusActive: entity.statusActive,
      toplnId: entity.toplnId,
    );
  }
}
