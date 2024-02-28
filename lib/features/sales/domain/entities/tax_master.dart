// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TaxMasterEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String taxCode;
  final String description;
  final double rate;
  final DateTime periodFrom;
  final DateTime periodTo;
  final String taxType;
  final int statusActive;
  final int activated;

  TaxMasterEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.taxCode,
    required this.description,
    required this.rate,
    required this.periodFrom,
    required this.periodTo,
    required this.taxType,
    required this.statusActive,
    required this.activated,
  });

  TaxMasterEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? taxCode,
    String? description,
    double? rate,
    DateTime? periodFrom,
    DateTime? periodTo,
    String? taxType,
    int? statusActive,
    int? activated,
  }) {
    return TaxMasterEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      taxCode: taxCode ?? this.taxCode,
      description: description ?? this.description,
      rate: rate ?? this.rate,
      periodFrom: periodFrom ?? this.periodFrom,
      periodTo: periodTo ?? this.periodTo,
      taxType: taxType ?? this.taxType,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'taxCode': taxCode,
      'description': description,
      'rate': rate,
      'periodFrom': periodFrom.millisecondsSinceEpoch,
      'periodTo': periodTo.millisecondsSinceEpoch,
      'taxType': taxType,
      'statusActive': statusActive,
      'activated': activated,
    };
  }

  factory TaxMasterEntity.fromMap(Map<String, dynamic> map) {
    return TaxMasterEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      taxCode: map['taxCode'] as String,
      description: map['description'] as String,
      rate: map['rate'] as double,
      periodFrom: DateTime.fromMillisecondsSinceEpoch(map['periodFrom'] as int),
      periodTo: DateTime.fromMillisecondsSinceEpoch(map['periodTo'] as int),
      taxType: map['taxType'] as String,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaxMasterEntity.fromJson(String source) =>
      TaxMasterEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaxMasterEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, taxCode: $taxCode, description: $description, rate: $rate, periodFrom: $periodFrom, periodTo: $periodTo, taxType: $taxType, statusActive: $statusActive, activated: $activated)';
  }

  @override
  bool operator ==(covariant TaxMasterEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.taxCode == taxCode &&
        other.description == description &&
        other.rate == rate &&
        other.periodFrom == periodFrom &&
        other.periodTo == periodTo &&
        other.taxType == taxType &&
        other.statusActive == statusActive &&
        other.activated == activated;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        taxCode.hashCode ^
        description.hashCode ^
        rate.hashCode ^
        periodFrom.hashCode ^
        periodTo.hashCode ^
        taxType.hashCode ^
        statusActive.hashCode ^
        activated.hashCode;
  }
}
