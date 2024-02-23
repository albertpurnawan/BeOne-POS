import 'package:pos_fe/features/sales/domain/entities/pricelist_period.dart';

const String tablePricelistPeriods = 'tpln1';

class PricelistPeriodFields {
  static const List<String> values = [
    id,
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

  static const String id = "_id";
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

class PricelistPeriodModel extends PricelistPeriodEntity {
  PricelistPeriodModel({
    required super.id,
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
      '_id': id,
      'docid': docId,
      'createdate': createDate.toUtc().millisecondsSinceEpoch,
      'updatedate': updateDate?.toUtc().millisecondsSinceEpoch,
      'toplnId': toplnId,
      'periodfr': periodFr.toUtc().millisecondsSinceEpoch,
      'periodto': periodTo.toUtc().millisecondsSinceEpoch,
      'baseprice': basePrice,
      'periodprice': periodPrice,
      'factor': factor,
      'statusactive': statusActive,
      'activated': activated,
    };
  }

  factory PricelistPeriodModel.fromMap(Map<String, dynamic> map) {
    return PricelistPeriodModel(
      id: map['_id'] as int,
      docId: map['docid'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createdate'] as int)
          .toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedate'] as int)
              .toLocal()
          : null,
      toplnId: map['toplnId'] != null ? map['toplnId'] as int : null,
      periodFr:
          DateTime.fromMillisecondsSinceEpoch(map['periodfr'] as int).toLocal(),
      periodTo:
          DateTime.fromMillisecondsSinceEpoch(map['periodto'] as int).toLocal(),
      basePrice: map['baseprice'] as int,
      periodPrice: map['periodprice'] as int,
      factor: map['factor'] as double,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
    );
  }

  factory PricelistPeriodModel.fromEntity(PricelistPeriodEntity entity) {
    return PricelistPeriodModel(
      id: entity.id,
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
