import 'package:pos_fe/features/sales/domain/entities/pricelist.dart';

const String tablePricelists = "topln";

class PricelistFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    priceCode,
    description,
    basePrice,
    periodPrice,
    factor,
    tcurrId,
    type,
    statusactive,
    activated,
  ];

  static const String id = "_id";
  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String priceCode = "pricecode";
  static const String description = "description";
  static const String basePrice = "baseprice";
  static const String periodPrice = "periodprice";
  static const String factor = "factor";
  static const String tcurrId = "tcurrId";
  static const String type = "type";
  static const String statusactive = "statusactive";
  static const String activated = "activated";
}

class PricelistModel extends PricelistEntity {
  PricelistModel({
    required super.id,
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.priceCode,
    required super.description,
    required super.basePrice,
    required super.periodPrice,
    required super.factor,
    required super.tcurrId,
    required super.type,
    required super.statusactive,
    required super.activated,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'docid': docId,
      'createdate': createDate.toUtc().millisecondsSinceEpoch,
      'updatedate': updateDate?.toUtc().millisecondsSinceEpoch,
      'pricecode': priceCode,
      'description': description,
      'baseprice': basePrice,
      'periodprice': periodPrice,
      'factor': factor,
      'tcurrId': tcurrId,
      'type': type,
      'statusactive': statusactive,
      'activated': activated,
    };
  }

  factory PricelistModel.fromMap(Map<String, dynamic> map) {
    return PricelistModel(
      id: map['_id'] as int, // id not returned
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int)
          .toLocal(),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
              .toLocal()
          : null,
      priceCode: map['priceCode'] as String,
      description: map['description'] as String,
      basePrice: map['basePrice'] as int,
      periodPrice: map['periodPrice'] as int,
      // factor returned int
      factor: map['factor'] as double,
      //tcurrId returned docid as tcurr_id: {docid: cff4edc0-7612-4681-8d7c-c90e9e97c6dc, curcode: IDR, description: Rupiah}
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as int : null,
      type: map['type'] as int,
      statusactive: map['statusactive'] as int,
      activated: map['activated'] as int,
    );
  }

  factory PricelistModel.fromEntity(PricelistEntity entity) {
    return PricelistModel(
      id: entity.id,
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      priceCode: entity.priceCode,
      description: entity.description,
      basePrice: entity.basePrice,
      periodPrice: entity.periodPrice,
      factor: entity.factor,
      tcurrId: entity.tcurrId,
      type: entity.type,
      statusactive: entity.statusactive,
      activated: entity.activated,
    );
  }
}
