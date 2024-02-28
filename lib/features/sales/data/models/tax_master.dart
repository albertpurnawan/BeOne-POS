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
  static const String updateDate = "updateDate";
  static const String taxCode = "taxCode";
  static const String description = "description";
  static const String rate = "rate";
  static const String periodFrom = "periodFrom";
  static const String periodTo = "periodTo";
  static const String taxType = "taxType";
  static const String statusActive = "statusActive";
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
      'docId': docId,
      'createDate': createDate.toUtc().toIso8601String(),
      'updateDate': updateDate?.toUtc().toIso8601String(),
      'taxCode': taxCode,
      'description': description,
      'rate': rate,
      'periodFrom': periodFrom.toUtc().toIso8601String(),
      'periodTo': periodTo.toUtc().toIso8601String(),
      'taxType': taxType,
      'statusActive': statusActive,
      'activated': activated,
    };
  }

  factory TaxMasterModel.fromMap(Map<String, dynamic> map) {
    return TaxMasterModel(
      docId: map['docId'] as String,
      createDate: DateTime.parse(map['createDate'] as String),
      updateDate: map['updateDate'] != null
          ? DateTime.parse(map['updateDate'] as String)
          : null,
      taxCode: map['taxCode'] as String,
      description: map['description'] as String,
      rate: map['rate'] as double,
      periodFrom: DateTime.parse(map['periodFrom'] as String),
      periodTo: DateTime.parse(map['periodTo'] as String),
      taxType: map['taxType'] as String,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
    );
  }
}
