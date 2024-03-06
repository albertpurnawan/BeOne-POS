import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_package_header.dart';

const String tablePromoPackageHeader = "toprk";

class PromoPackageHeaderFields {
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
    discount,
    discType,
    globalDisc,
    minQuantity,
    statusActive,
    // toplnId,
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
  static const String discount = "discount";
  static const String discType = "disctype";
  static const String globalDisc = "globaldisc";
  static const String minQuantity = "minquantity";
  static const String statusActive = "statusactive";
  // static const String toplnId = "toplnId";
}

class PromoPackageHeaderModel extends PromoPackageHeaderEntity
    implements BaseModel {
  PromoPackageHeaderModel({
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
    required super.discount,
    required super.discType,
    required super.globalDisc,
    required super.minQuantity,
    required super.statusActive,
    // required super.toplnId,
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
      'discount': discount,
      'disctype': discType,
      'globaldisc': globalDisc,
      'minquantity': minQuantity,
      'statusactive': statusActive,
      // 'toplnId': toplnId,
    };
  }

  factory PromoPackageHeaderModel.fromMap(Map<String, dynamic> map) {
    return PromoPackageHeaderModel(
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
      discount: map['discount'] as double,
      discType: map['disctype'] as int,
      globalDisc: map['globaldisc'] as String,
      minQuantity: map['minquantity'] as double,
      statusActive: map['statusactive'] as int,
      // toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
    );
  }

  factory PromoPackageHeaderModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoPackageHeaderModel.fromMap({
      ...map,
      // "toplnId": map['topln_id']?['docid'] != null
      //     ? map['topln_id']['docid'] as String
      //     : null,
      "discount": map['discount'].toDouble() as double,
      "minquantity": map['minquantity'].toDouble() as double,
    });
  }

  factory PromoPackageHeaderModel.fromEntity(PromoPackageHeaderEntity entity) {
    return PromoPackageHeaderModel(
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
      discount: entity.discount,
      discType: entity.discType,
      globalDisc: entity.globalDisc,
      minQuantity: entity.minQuantity,
      statusActive: entity.statusActive,
      // toplnId: entity.toplnId,
    );
  }
}
