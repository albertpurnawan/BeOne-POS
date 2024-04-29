import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_harga_spesial_header.dart';

const String tablePromoHargaSpecialHeader = "topsb";

class PromoHargaSpesialHeaderFields {
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
    maxPurchaseDay,
    maxPurchaseTransaction,
    validMultiply,
    quota,
    promoAlias,
    toitmId,
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
  static const String maxPurchaseDay = "maxpurchaseday";
  static const String maxPurchaseTransaction = "maxpurchasetransaction";
  static const String validMultiply = "validmultiply";
  static const String quota = "quota";
  static const String promoAlias = "promoalias";
  static const String toitmId = "toitmId";
}

class PromoHargaSpesialHeaderModel extends PromoHargaSpesialHeaderEntity
    implements BaseModel {
  PromoHargaSpesialHeaderModel({
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
    required super.maxPurchaseDay,
    required super.maxPurchaseTransaction,
    required super.validMultiply,
    required super.quota,
    required super.promoAlias,
    required super.toitmId,
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
      'maxpurchaseday': maxPurchaseDay,
      'maxpurchasetransaction': maxPurchaseTransaction,
      'validmultiply': validMultiply,
      'quota': quota,
      'promoalias': promoAlias,
      'toitmId': toitmId,
    };
  }

  factory PromoHargaSpesialHeaderModel.fromMap(Map<String, dynamic> map) {
    return PromoHargaSpesialHeaderModel(
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
      maxPurchaseDay: map['maxpurchaseday'] as int,
      maxPurchaseTransaction: map['maxpurchasetransaction'] as int,
      validMultiply: map['validmultiply'] as int,
      quota: map['quota'] as double,
      promoAlias: map['promoalias'] as int,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
    );
  }

  factory PromoHargaSpesialHeaderModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoHargaSpesialHeaderModel.fromMap({
      ...map,
      'toitmId': map['toitmdocid'] != null ? map['toitmdocid'] as String : null,
    });
  }

  factory PromoHargaSpesialHeaderModel.fromEntity(
      PromoHargaSpesialHeaderEntity entity) {
    return PromoHargaSpesialHeaderModel(
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
      maxPurchaseDay: entity.maxPurchaseDay,
      maxPurchaseTransaction: entity.maxPurchaseTransaction,
      validMultiply: entity.validMultiply,
      quota: entity.quota,
      promoAlias: entity.promoAlias,
      toitmId: entity.toitmId,
    );
  }
}
