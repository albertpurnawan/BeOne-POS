import 'package:pos_fe/features/sales/domain/entities/tax_master.dart';

const String tableTaxMasters = "tovat";

class TaxMasterFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    taxCode,
    description,
    rate,
    periodFrom,
    periodTo,
    taxType,
    statusActive,
    activated
  ];

  static const String docId = "docId";
  static const String createDate = "createDate";
  static const String updateDate = "updatedate";
  static const String taxCode = "taxcode";
  static const String description = "description";
  static const String rate = "rate";
  static const String periodFrom = "periodfrom";
  static const String periodTo = "periodto";
  static const String taxType = "taxtype";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
}

class TaxMasterModel extends TaxMasterEntity {
  TaxMasterModel(
      {required super.docId,
      required super.createDate,
      required super.updateDate,
      required super.taxCode,
      required super.description,
      required super.rate,
      required super.periodFrom,
      required super.periodTo,
      required super.taxType,
      required super.statusActive,
      required super.activated});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'taxcode': taxCode,
      'description': description,
      'rate': rate,
      'periodfrom': periodFrom.toUtc().toIso8601String(),
      'periodto': periodTo.toUtc().toIso8601String(),
      'taxtype': taxType,
      'statusactive': statusActive,
      'activated': activated,
    };
  }

  factory TaxMasterModel.fromMap(Map<String, dynamic> map) {
    return TaxMasterModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updateDate'] as String)
          : null,
      taxCode: map['taxcode'] as String,
      description: map['description'] as String,
      rate: map['rate'] as double,
      periodFrom: DateTime.parse(map['periodfrom'] as String),
      periodTo: DateTime.parse(map['periodto'] as String),
      taxType: map['taxtype'] as String,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
    );
  }

  factory TaxMasterModel.fromMapRemote(Map<String, dynamic> map) {
    return TaxMasterModel.fromMap({
      ...map,
      "rate": map['rate'].toDouble() as double,
    });
  }
}
