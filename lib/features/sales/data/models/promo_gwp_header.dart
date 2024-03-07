import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_gwp_header.dart';

const String tablePromoGWPHeader = "toprg";

class PromoGWPHeaderFields {
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
    priority,
    priorityNo,
    minPurchase,
    maxGet,
    getCondition,
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
  static const String priority = "priority";
  static const String priorityNo = "priorityno";
  static const String minPurchase = "minpurchase";
  static const String maxGet = "maxget";
  static const String getCondition = "getcondition";
  static const String statusActive = "statusactive";
}

class PromoGWPHeaderModel extends PromoGWPHeaderEntity implements BaseModel {
  PromoGWPHeaderModel({
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
    required super.priority,
    required super.priorityNo,
    required super.minPurchase,
    required super.maxGet,
    required super.getCondition,
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
      'priority': priority,
      'priorityno': priorityNo,
      'minpurchase': minPurchase,
      'maxget': maxGet,
      'getcondition': getCondition,
      'statusactive': statusActive,
    };
  }

  factory PromoGWPHeaderModel.fromMap(Map<String, dynamic> map) {
    return PromoGWPHeaderModel(
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
      priority: map['priority'] as int,
      priorityNo: map['priorityno'] as int,
      minPurchase: map['minpurchase'] as double,
      maxGet: map['maxget'] as double,
      getCondition: map['getcondition'] as String,
      statusActive: map['statusactive'] as int,
    );
  }

  factory PromoGWPHeaderModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoGWPHeaderModel.fromMap({
      ...map,
      "minpurchase": map['minpurchase'].toDouble() as double,
      "maxget": map['maxget'].toDouble() as double,
    });
  }

  factory PromoGWPHeaderModel.fromEntity(PromoGWPHeaderEntity entity) {
    return PromoGWPHeaderModel(
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
      priority: entity.priority,
      priorityNo: entity.priorityNo,
      minPurchase: entity.minPurchase,
      maxGet: entity.maxGet,
      getCondition: entity.getCondition,
      statusActive: entity.statusActive,
    );
  }
}
