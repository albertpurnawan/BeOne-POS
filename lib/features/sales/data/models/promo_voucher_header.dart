import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_voucher_header.dart';

const String tablePromoVoucherHeader = "toprr";

class PromoVoucherHeaderFields {
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
    validDays,
    minPurchase,
    minNextPurchase,
    minNextPurchasex,
    voucherType,
    voucherValue,
    voucherPct,
    statusActive,
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
  static const String validDays = "validays";
  static const String minPurchase = "minpurchase";
  static const String minNextPurchase = "minnextpurchase";
  static const String minNextPurchasex = "minnextpurchasex";
  static const String voucherType = "vouchertype";
  static const String voucherValue = "vouchervalue";
  static const String voucherPct = "voucherpct";
  static const String statusActive = "statusactive";
}

class PromoVoucherHeaderModel extends PromoVoucherHeaderEntity
    implements BaseModel {
  PromoVoucherHeaderModel({
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
    required super.validDays,
    required super.minPurchase,
    required super.minNextPurchase,
    required super.minNextPurchasex,
    required super.voucherType,
    required super.voucherValue,
    required super.voucherPct,
    required super.statusActive,
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
      'validdays': validDays,
      'minpurchase': minPurchase,
      'minnextpurchase': minNextPurchase,
      'minnextpurchasex': minNextPurchasex,
      'vouchertype': voucherType,
      'vouchervalue': voucherValue,
      'voucherpct': voucherPct,
      'statusactive': statusActive,
    };
  }

  factory PromoVoucherHeaderModel.fromMap(Map<String, dynamic> map) {
    return PromoVoucherHeaderModel(
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
      validDays: map['validdays'] as int,
      minPurchase: map['minpurchase'] as double,
      minNextPurchase: map['minnextpurchase'] as double,
      minNextPurchasex: map['minnextpurchasex'] as int,
      voucherType: map['vouchertype'] as String,
      voucherValue: map['vouchervalue'] as double,
      voucherPct: map['voucherpct'] as double,
      statusActive: map['statusactive'] as int,
    );
  }

  factory PromoVoucherHeaderModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoVoucherHeaderModel.fromMap({
      ...map,
      "minpurchase": map['minpurchase'].toDouble() as double,
      "minnextpurchase": map['minnextpurchase'].toDouble() as double,
      "vouchervalue": map['vouchervalue'].toDouble() as double,
      "voucherpct": map['voucherpct'].toDouble() as double,
    });
  }

  factory PromoVoucherHeaderModel.fromEntity(PromoVoucherHeaderEntity entity) {
    return PromoVoucherHeaderModel(
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
      validDays: entity.validDays,
      minPurchase: entity.minPurchase,
      minNextPurchase: entity.minNextPurchase,
      minNextPurchasex: entity.minNextPurchasex,
      voucherType: entity.voucherType,
      voucherValue: entity.voucherValue,
      voucherPct: entity.voucherPct,
      statusActive: entity.statusActive,
    );
  }
}
