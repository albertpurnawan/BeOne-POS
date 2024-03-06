import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_header.dart';

const String tablePromoCouponHeader = "toprn";

class PromoCouponHeaderFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    couponCode,
    description,
    startDate,
    endDate,
    startTime,
    endTime,
    remarks,
    includePromo,
    maxTimes,
    minPurchase,
    generalDisc,
    maxGeneralDisc,
    memberDisc,
    maxMemberDisc,
    statusActive,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String couponCode = "couponcode";
  static const String description = "description";
  static const String startDate = "startdate";
  static const String endDate = "enddate";
  static const String startTime = "starttime";
  static const String endTime = "endtime";
  static const String remarks = "remarks";
  static const String includePromo = "includepromo";
  static const String maxTimes = "maxtimes";
  static const String minPurchase = "minpurchase";
  static const String generalDisc = "generaldisc";
  static const String maxGeneralDisc = "maxgeneraldisc";
  static const String memberDisc = "memberdisc";
  static const String maxMemberDisc = "maxmemberdisc";
  static const String statusActive = "statusactive";
}

class PromoCouponHeaderModel extends PromoCouponHeaderEntity
    implements BaseModel {
  PromoCouponHeaderModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.couponCode,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.startTime,
    required super.endTime,
    required super.remarks,
    required super.includePromo,
    required super.maxTimes,
    required super.minPurchase,
    required super.generalDisc,
    required super.maxGeneralDisc,
    required super.memberDisc,
    required super.maxMemberDisc,
    required super.statusActive,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'couponcode': couponCode,
      'description': description,
      'startdate': startDate.toUtc().toIso8601String(),
      'enddate': endDate.toUtc().toIso8601String(),
      'starttime': startTime.toUtc().toIso8601String(),
      'endtime': endTime.toUtc().toIso8601String(),
      'remarks': remarks,
      'includepromo': includePromo,
      'maxtimes': maxTimes,
      'minpurchase': minPurchase,
      'generaldisc': generalDisc,
      'maxgeneraldisc': maxGeneralDisc,
      'memberisc': memberDisc,
      'maxmemberisc': maxMemberDisc,
      'statusactive': statusActive,
    };
  }

  factory PromoCouponHeaderModel.fromMap(Map<String, dynamic> map) {
    return PromoCouponHeaderModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      couponCode: map['couponcode'] as String,
      description: map['description'] as String,
      startDate: DateTime.parse(map['startdate'] as String).toLocal(),
      endDate: DateTime.parse(map['enddate'] as String).toLocal(),
      startTime: DateTime.parse(map['starttime'] as String).toLocal(),
      endTime: DateTime.parse(map['endtime'] as String).toLocal(),
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      includePromo: map['includepromo'] as int,
      maxTimes: map['maxtimes'] as int,
      minPurchase: map['minpurchase'] as double,
      generalDisc: map['generaldisc'] as double,
      maxGeneralDisc: map['maxgeneraldisc'] as String,
      memberDisc: map['memberisc'] as double,
      maxMemberDisc: map['maxmemberisc'] as double,
      statusActive: map['statusactive'] as int,
    );
  }

  factory PromoCouponHeaderModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoCouponHeaderModel.fromMap({
      ...map,
      "minpurchase": map['minpurchase'].toDouble() as double,
      "generaldisc": map['generaldisc'].toDouble() as double,
      "memberdisc": map['memberisc'].toDouble() as double,
      "maxMemberdisc": map['maxmemberisc'].toDouble() as double,
    });
  }

  factory PromoCouponHeaderModel.fromEntity(PromoCouponHeaderEntity entity) {
    return PromoCouponHeaderModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      couponCode: entity.couponCode,
      description: entity.description,
      startDate: entity.startDate,
      endDate: entity.endDate,
      startTime: entity.startTime,
      endTime: entity.endTime,
      remarks: entity.remarks,
      includePromo: entity.includePromo,
      maxTimes: entity.maxTimes,
      minPurchase: entity.minPurchase,
      generalDisc: entity.generalDisc,
      maxGeneralDisc: entity.maxGeneralDisc,
      memberDisc: entity.memberDisc,
      maxMemberDisc: entity.maxMemberDisc,
      statusActive: entity.statusActive,
    );
  }
}
