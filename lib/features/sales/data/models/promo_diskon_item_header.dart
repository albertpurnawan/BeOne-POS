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
      'statusActive': statusActive,
      'promoType': promoType,
      'buyCondition': buyCondition,
      'promoValue': promoValue,
      'discount1': discount1,
      'discount2': discount2,
      'discount3': discount3,
      'totalQtyFrom': totalQtyFrom,
      'totalQtyTo': totalQtyTo,
      'totalPriceFrom': totalPriceFrom,
      'totalPriceTo': totalPriceTo,
    };
  }

  factory PromoDiskonItemHeaderModel.fromMap(Map<String, dynamic> map) {
    return PromoDiskonItemHeaderModel(
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
      statusActive: map['statusActive'] as int,
      promoType: map['promoType'] as int,
      buyCondition: map['buyCondition'] as int,
      promoValue: map['promoValue'] as double,
      discount1: map['discount1'] as double,
      discount2: map['discount2'] as double,
      discount3: map['discount3'] as double,
      totalQtyFrom:
          map['totalQtyFrom'] != null ? map['totalQtyFrom'] as double : null,
      totalQtyTo:
          map['totalQtyTo'] != null ? map['totalQtyTo'] as double : null,
      totalPriceFrom: map['totalPriceFrom'] != null
          ? map['totalPriceFrom'] as double
          : null,
      totalPriceTo:
          map['totalPriceTo'] != null ? map['totalPriceTo'] as double : null,
    );
  }

  factory PromoDiskonItemHeaderModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoDiskonItemHeaderModel.fromMap({
      ...map,
      "discount1": map['discount1'] != null
          ? double.tryParse(map['discount1'].toString())
          : null,
      "discount2": map['discount2'] != null
          ? double.tryParse(map['discount2'].toString())
          : null,
      "discount3": map['discount3'] != null
          ? double.tryParse(map['discount3'].toString())
          : null,
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
