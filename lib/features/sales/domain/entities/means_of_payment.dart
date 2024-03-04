// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MeansOfPaymentEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topmtId;
  final String mopCode;
  final String description;
  final String mopAlias;
  final double bankCharge;
  final int consolidation;
  final int credit;
  final int subType;
  final int validForEmp;

  MeansOfPaymentEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.topmtId,
    required this.mopCode,
    required this.description,
    required this.mopAlias,
    required this.bankCharge,
    required this.consolidation,
    required this.credit,
    required this.subType,
    required this.validForEmp,
  });

  MeansOfPaymentEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topmtId,
    String? mopCode,
    String? description,
    String? mopAlias,
    double? bankCharge,
    int? consolidation,
    int? credit,
    int? subType,
    int? validForEmp,
  }) {
    return MeansOfPaymentEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topmtId: topmtId ?? this.topmtId,
      mopCode: mopCode ?? this.mopCode,
      description: description ?? this.description,
      mopAlias: mopAlias ?? this.mopAlias,
      bankCharge: bankCharge ?? this.bankCharge,
      consolidation: consolidation ?? this.consolidation,
      credit: credit ?? this.credit,
      subType: subType ?? this.subType,
      validForEmp: validForEmp ?? this.validForEmp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'topmtId': topmtId,
      'mopCode': mopCode,
      'description': description,
      'mopAlias': mopAlias,
      'bankCharge': bankCharge,
      'consolidation': consolidation,
      'credit': credit,
      'subType': subType,
      'validForEmp': validForEmp,
    };
  }

  factory MeansOfPaymentEntity.fromMap(Map<String, dynamic> map) {
    return MeansOfPaymentEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      topmtId: map['topmtId'] != null ? map['topmtId'] as String : null,
      mopCode: map['mopCode'] as String,
      description: map['description'] as String,
      mopAlias: map['mopAlias'] as String,
      bankCharge: map['bankCharge'] as double,
      consolidation: map['consolidation'] as int,
      credit: map['credit'] as int,
      subType: map['subType'] as int,
      validForEmp: map['validForEmp'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MeansOfPaymentEntity.fromJson(String source) =>
      MeansOfPaymentEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MeansOfPaymentEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topmtId: $topmtId, mopCode: $mopCode, description: $description, mopAlias: $mopAlias, bankCharge: $bankCharge, consolidation: $consolidation, credit: $credit, subType: $subType, validForEmp: $validForEmp)';
  }

  @override
  bool operator ==(covariant MeansOfPaymentEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topmtId == topmtId &&
        other.mopCode == mopCode &&
        other.description == description &&
        other.mopAlias == mopAlias &&
        other.bankCharge == bankCharge &&
        other.consolidation == consolidation &&
        other.credit == credit &&
        other.subType == subType &&
        other.validForEmp == validForEmp;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        topmtId.hashCode ^
        mopCode.hashCode ^
        description.hashCode ^
        mopAlias.hashCode ^
        bankCharge.hashCode ^
        consolidation.hashCode ^
        credit.hashCode ^
        subType.hashCode ^
        validForEmp.hashCode;
  }
}