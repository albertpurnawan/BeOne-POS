import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_bertingkat.dart';

const String tablePromoBertingkat = "toprp";

class PromoBertingkatFields {
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
  static const String statusActive = "statusactive";
  static const String toplnId = "toplnId";
}

class PromoBertingkatModel extends PromoBertingkatEntity implements BaseModel {
  PromoBertingkatModel({
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
      'statusactive': statusActive,
      'toplnId': toplnId,
    };
  }

  factory PromoBertingkatModel.fromMap(Map<String, dynamic> map) {
    return PromoBertingkatModel(
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
      toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
    );
  }

  factory PromoBertingkatModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoBertingkatModel.fromMap({
      ...map,
      "toplnId": map['topln_id']?['docid'] != null
          ? map['topln_id']['docid'] as String
          : null,
    });
  }

  factory PromoBertingkatModel.fromEntity(PromoBertingkatEntity entity) {
    return PromoBertingkatModel(
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
      toplnId: entity.toplnId,
    );
  }
}
