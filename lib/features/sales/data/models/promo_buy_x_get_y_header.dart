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
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'promocode': promoCode,
      'description': description,
      'startdate': startDate.toUtc().toIso8601String(),
      'enddate': endDate.toUtc().toIso8601String(),
      'starttime': startTime.toUtc().toIso8601String(),
      'endtime': endTime.toUtc().toIso8601String(),
      'remarks': remarks,
      'minpurchase': minPurchase,
      'buycondition': buyCondition,
      'minbuy': minBuy,
      'maxmultiply': maxMultiply,
      'getcondition': getCondition,
      'maxget': maxGet,
      'statusactive': statusActive,
      'toplnId': toplnId,
    };
  }

  factory PromoBuyXGetYHeaderModel.fromMap(Map<String, dynamic> map) {
    return PromoBuyXGetYHeaderModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      promoCode: map['promocode'] as String,
      description: map['description'] as String,
      startDate: DateTime.parse(map['startdate'] as String).toLocal(),
      endDate: DateTime.parse(map['enddate'] as String).toLocal(),
      startTime: DateTime.parse(map['starttime'] as String).toLocal(),
      endTime: DateTime.parse(map['endtime'] as String).toLocal(),
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      minPurchase: map['minpurchase'] as double,
      buyCondition: map['buycondition'] as int,
      minBuy: map['minbuy'] as double,
      maxMultiply: map['maxmultiply'] as double,
      getCondition: map['getcondition'] as int,
      maxGet: map['maxget'] as double,
      statusActive: map['statusactive'] as int,
      toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
    );
  }

  factory PromoBuyXGetYHeaderModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoBuyXGetYHeaderModel.fromMap({
      ...map,
      'toplnId': map['toplndocid'] != null ? map['toplndocid'] as String : null,
      'minpurchase': double.tryParse(map['minpurchase'].toString()),
      'minbuy': double.tryParse(map['minbuy'].toString()),
      'maxmultiply': double.tryParse(map['maxmultiply'].toString()),
      'maxget': double.tryParse(map['maxget'].toString()),
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
