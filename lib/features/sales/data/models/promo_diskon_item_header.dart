import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_diskon_item_header.dart';

const String tablePromoDiskonItemHeader = "topdi";

class PromoDiskonItemHeaderFields {
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
    promoValue,
    discount1,
    discount2,
    discount3,
    totalQtyFrom,
    totalQtyTo,
    totalPriceFrom,
    totalPriceTo,
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
  static const String promoValue = "promovalue";
  static const String discount1 = "discount1";
  static const String discount2 = "discount2";
  static const String discount3 = "discount3";
  static const String totalQtyFrom = "totalqtyfrom";
  static const String totalQtyTo = "totalqtyto";
  static const String totalPriceFrom = "totalpricefrom";
  static const String totalPriceTo = "totalpriceto";
}

class PromoDiskonItemHeaderModel extends PromoDiskonItemHeaderEntity
    implements BaseModel {
  PromoDiskonItemHeaderModel({
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
    required super.promoValue,
    required super.discount1,
    required super.discount2,
    required super.discount3,
    required super.totalQtyFrom,
    required super.totalQtyTo,
    required super.totalPriceFrom,
    required super.totalPriceTo,
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
      'promovalue': promoValue,
      'discount1': discount1,
      'discount2': discount2,
      'discount3': discount3,
      'totalqtyfrom': totalQtyFrom,
      'totalqtyto': totalQtyTo,
      'totalpricefrom': totalPriceFrom,
      'totalpriceto': totalPriceTo,
    };
  }

  factory PromoDiskonItemHeaderModel.fromMap(Map<String, dynamic> map) {
    return PromoDiskonItemHeaderModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      promoCode: map['promocode'] as String,
      description: map['description'] as String,
      startDate: DateTime.parse(map['startdate'] as String).toLocal(),
      endDate: DateTime.parse(map['enddate'] as String).toLocal(),
      startTime: DateTime.parse(map['starttime'] as String),
      endTime: DateTime.parse(map['endtime'] as String),
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      statusActive: map['statusactive'] as int,
      promoType: map['promotype'] as int,
      buyCondition: map['buycondition'] as int,
      promoValue: map['promovalue'] as double,
      discount1: map['discount1'] as double,
      discount2: map['discount2'] as double,
      discount3: map['discount3'] as double,
      totalQtyFrom:
          map['totalqtyfrom'] != null ? map['totalqtyfrom'] as double : null,
      totalQtyTo:
          map['totalqtyto'] != null ? map['totalqtyto'] as double : null,
      totalPriceFrom: map['totalpricefrom'] != null
          ? map['totalpricefrom'] as double
          : null,
      totalPriceTo:
          map['totalpriceto'] != null ? map['totalpriceto'] as double : null,
    );
  }

  factory PromoDiskonItemHeaderModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoDiskonItemHeaderModel.fromMap({
      ...map,
      "promovalue": double.tryParse(map['promovalue'].toString()),
      "discount1": double.tryParse(map['discount1'].toString()),
      "discount2": double.tryParse(map['discount2'].toString()),
      "discount3": double.tryParse(map['discount3'].toString()),
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

  factory PromoDiskonItemHeaderModel.fromEntity(
      PromoDiskonItemHeaderEntity entity) {
    return PromoDiskonItemHeaderModel(
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
      promoValue: entity.promoValue,
      discount1: entity.discount1,
      discount2: entity.discount2,
      discount3: entity.discount3,
      totalQtyFrom: entity.totalQtyFrom,
      totalQtyTo: entity.totalQtyTo,
      totalPriceFrom: entity.totalPriceFrom,
      totalPriceTo: entity.totalPriceTo,
    );
  }
}
