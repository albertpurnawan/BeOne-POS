import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_spesial_multi_item_header.dart';

const String tablePromoSpesialMultiItemHeader = "topsm";

class PromoSpesialMultiItemHeaderFields {
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
    condition,
    form,
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
  static const String condition = "condition";
  static const String form = "form";
}

class PromoSpesialMultiItemHeaderModel extends PromoSpesialMultiItemHeaderEntity implements BaseModel {
  PromoSpesialMultiItemHeaderModel({
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
    required super.condition,
    required super.form,
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
      'condition': condition,
      'form': form,
    };
  }

  factory PromoSpesialMultiItemHeaderModel.fromMap(Map<String, dynamic> map) {
    return PromoSpesialMultiItemHeaderModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate'] as String).toLocal() : null,
      promoCode: map['promocode'] as String,
      description: map['description'] as String,
      startDate: DateTime.parse(map['startdate'] as String).toLocal(),
      endDate: DateTime.parse(map['enddate'] as String).toLocal(),
      startTime: DateTime.parse(map['starttime'] as String),
      endTime: DateTime.parse(map['endtime'] as String),
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      statusActive: map['statusactive'] as int,
      condition: map['condition'] as int,
      form: map['form'] as String,
    );
  }

  factory PromoSpesialMultiItemHeaderModel.fromEntity(PromoSpesialMultiItemHeaderEntity entity) {
    return PromoSpesialMultiItemHeaderModel(
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
      condition: entity.condition,
      form: entity.form,
    );
  }
}
