import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_bonus_multi_item_header.dart';

const String tablePromoBonusMultiItemHeader = "topmi";

class PromoBonusMultiItemHeaderFields {
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
    statusActive,
    promoType,
    buyCondition,
    getCondition,
    totalQtyFrom,
    totalQtyTo,
    totalPriceFrom,
    totalPriceTo,
    validMultiply,
    promoAlias,
    transactionLimit,
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
  static const String statusActive = "statusactive";
  static const String promoType = "promotype";
  static const String buyCondition = "buycondition";
  static const String getCondition = "getcondition";
  static const String totalQtyFrom = "totalqtyfrom";
  static const String totalQtyTo = "totalqtyto";
  static const String totalPriceFrom = "totalpricefrom";
  static const String totalPriceTo = "totalpriceto";
  static const String validMultiply = "validmultiply";
  static const String promoAlias = "promoalias";
  static const String transactionLimit = "transactionlimit";
}

class PromoBonusMultiItemHeaderModel extends PromoBonusMultiItemHeaderEntity
    implements BaseModel {
  PromoBonusMultiItemHeaderModel({
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
    required super.statusActive,
    required super.promoType,
    required super.buyCondition,
    required super.getCondition,
    required super.totalQtyFrom,
    required super.totalQtyTo,
    required super.totalPriceFrom,
    required super.totalPriceTo,
    required super.validMultiply,
    required super.promoAlias,
    required super.transactionLimit,
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
      'statusactive': statusActive,
      'promotype': promoType,
      'buycondition': buyCondition,
      'getcondition': getCondition,
      'totalqtyfrom': totalQtyFrom,
      'totalqtyto': totalQtyTo,
      'totalpricefrom': totalPriceFrom,
      'totalpriceto': totalPriceTo,
      'validmultiply': validMultiply,
      'promoalias': promoAlias,
      'transactionlimit': transactionLimit,
    };
  }

  factory PromoBonusMultiItemHeaderModel.fromMap(Map<String, dynamic> map) {
    return PromoBonusMultiItemHeaderModel(
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
      statusActive: map['statusactive'] as int,
      promoType: map['promotype'] as int,
      buyCondition: map['buycondition'] as int,
      getCondition: map['getcondition'] as int,
      totalQtyFrom:
          map['totalqtyfrom'] != null ? map['totalqtyfrom'] as double : null,
      totalQtyTo:
          map['totalqtyto'] != null ? map['totalqtyto'] as double : null,
      totalPriceFrom: map['totalpricefrom'] != null
          ? map['totalpricefrom'] as double
          : null,
      totalPriceTo:
          map['totalpriceto'] != null ? map['totalpriceto'] as double : null,
      validMultiply: map['validmultiply'] as int,
      promoAlias: map['promoalias'] as int,
      transactionLimit: map['transactionlimit'] as int,
    );
  }

  factory PromoBonusMultiItemHeaderModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoBonusMultiItemHeaderModel.fromMap({
      ...map,
      "totalqtyfrom": map['totalqtyfrom'] != null
          ? double.tryParse(map['totalqtyfrom'].toString())
          : null,
      "totalqtyto": map['totalqtyto'] != null
          ? double.tryParse(map['totalqtyto'].toString())
          : null,
      "totalpricefrom": map['totalpricefrom'] != null
          ? double.tryParse(map['totalpricefrom'].toString())
          : null,
      "totalpriceto": map['totalpriceto'] != null
          ? double.tryParse(map['totalpriceto'].toString())
          : null,
    });
  }

  factory PromoBonusMultiItemHeaderModel.fromEntity(
      PromoBonusMultiItemHeaderEntity entity) {
    return PromoBonusMultiItemHeaderModel(
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
      statusActive: entity.statusActive,
      promoType: entity.promoType,
      buyCondition: entity.buyCondition,
      getCondition: entity.getCondition,
      totalQtyFrom: entity.totalQtyFrom,
      totalQtyTo: entity.totalQtyTo,
      totalPriceFrom: entity.totalPriceFrom,
      totalPriceTo: entity.totalPriceTo,
      validMultiply: entity.validMultiply,
      promoAlias: entity.promoAlias,
      transactionLimit: entity.transactionLimit,
    );
  }
}
