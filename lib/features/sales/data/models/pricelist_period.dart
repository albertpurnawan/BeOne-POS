import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/pricelist_period.dart';

const String tablePricelistPeriods = 'tpln1';

class PricelistPeriodFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toplnId,
    periodFr,
    periodTo,
    basePrice,
    periodPrice,
    factor,
    statusActive,
    activated,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toplnId = "toplnId";
  static const String periodFr = "periodfr";
  static const String periodTo = "periodto";
  static const String basePrice = "baseprice";
  static const String periodPrice = "periodprice";
  static const String factor = "factor";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
}

class PricelistPeriodModel extends PricelistPeriodEntity implements BaseModel {
  PricelistPeriodModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toplnId,
    required super.periodFr,
    required super.periodTo,
    required super.basePrice,
    required super.periodPrice,
    required super.factor,
    required super.statusActive,
    required super.activated,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toplnId': toplnId,
      'periodfr': periodFr.toUtc().toIso8601String(),
      'periodto': periodTo.toUtc().toIso8601String(),
      'baseprice': basePrice,
      'periodprice': periodPrice,
      'factor': factor,
      'statusactive': statusActive,
      'activated': activated,
    };
  }

  factory PricelistPeriodModel.fromMapRemote(Map<String, dynamic> map) {
    return PricelistPeriodModel.fromMap({
      ...map,
      "toplnId": map['topln_id']?['docid'] != null
          ? map['topln_id']['docid'] as String
          : null,
      "factor": map['factor'].toDouble() as double,
    });
  }

  factory PricelistPeriodModel.fromMap(Map<String, dynamic> map) {
    return PricelistPeriodModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
      periodFr: DateTime.parse(map['periodfr'] as String).toLocal(),
      periodTo: DateTime.parse(map['periodto'] as String).toLocal(),
      basePrice: map['baseprice'] as int,
      periodPrice: map['periodprice'] as int,
      factor: map['factor'] as double,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
    );
  }

  factory PricelistPeriodModel.fromEntity(PricelistPeriodEntity entity) {
    return PricelistPeriodModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toplnId: entity.toplnId,
      periodFr: entity.periodFr,
      periodTo: entity.periodTo,
      basePrice: entity.basePrice,
      periodPrice: entity.periodPrice,
      factor: entity.factor,
      statusActive: entity.statusActive,
      activated: entity.activated,
    );
  }
}
