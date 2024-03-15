import 'package:pos_fe/core/resources/base_model.dart';
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
    // periodPrice,
    factor,
    tcurrId,
    type,
    statusactive,
    activated,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String priceCode = "pricecode";
  static const String description = "description";
  static const String basePrice = "baseprice";
  // static const String periodPrice = "periodprice";
  static const String factor = "factor";
  static const String tcurrId = "tcurrId";
  static const String type = "type";
  static const String statusactive = "statusactive";
  static const String activated = "activated";
}

class PricelistModel extends PricelistEntity implements BaseModel {
  PricelistModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.priceCode,
    required super.description,
    required super.basePrice,
    // required super.periodPrice,
    required super.factor,
    required super.tcurrId,
    required super.type,
    required super.statusactive,
    required super.activated,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'pricecode': priceCode,
      'description': description,
      'baseprice': basePrice,
      // 'periodprice': periodPrice,
      'factor': factor,
      'tcurrId': tcurrId,
      'type': type,
      'statusactive': statusactive,
      'activated': activated,
    };
  }

  factory PricelistModel.fromMapRemote(Map<String, dynamic> map) {
    return PricelistModel.fromMap({
      ...map,
      "tcurrId": map['tcurrdocid'] != null ? map['tcurrdocid'] as String : null,
      "factor": map['factor'].toDouble() as double,
    });
  }

  factory PricelistModel.fromMap(Map<String, dynamic> map) {
    return PricelistModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      priceCode: map['pricecode'] as String,
      description: map['description'] as String,
      basePrice: map['baseprice'] as int,
      // periodPrice: map['periodprice'] as int,
      factor: map['factor'] as double,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
      type: map['type'] as int,
      statusactive: map['statusactive'] as int,
      activated: map['activated'] as int,
    );
  }

  factory PricelistModel.fromEntity(PricelistEntity entity) {
    return PricelistModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      priceCode: entity.priceCode,
      description: entity.description,
      basePrice: entity.basePrice,
      // periodPrice: entity.periodPrice,
      factor: entity.factor,
      tcurrId: entity.tcurrId,
      type: entity.type,
      statusactive: entity.statusactive,
      activated: entity.activated,
    );
  }
}
