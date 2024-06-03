// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MopSelectionEntity {
  final String tpmt3Id;
  final String tpmt1Id;
  final String mopAlias;
  final double? bankCharge;
  final String? payTypeCode;
  final String description;
  final double? amount;
  final int subType;

  MopSelectionEntity({
    required this.tpmt3Id,
    required this.tpmt1Id,
    required this.mopAlias,
    required this.bankCharge,
    required this.payTypeCode,
    required this.description,
    required this.amount,
    required this.subType,
  });

  MopSelectionEntity copyWith({
    String? tpmt3Id,
    String? tpmt1Id,
    String? mopAlias,
    double? bankCharge,
    String? payTypeCode,
    String? description,
    double? amount,
    int? subType,
  }) {
    return MopSelectionEntity(
      tpmt3Id: tpmt3Id ?? this.tpmt3Id,
      tpmt1Id: tpmt1Id ?? this.tpmt1Id,
      mopAlias: mopAlias ?? this.mopAlias,
      bankCharge: bankCharge ?? this.bankCharge,
      payTypeCode: payTypeCode ?? this.payTypeCode,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      subType: subType ?? this.subType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tpmt3Id': tpmt3Id,
      'tpmt1Id': tpmt1Id,
      'mopAlias': mopAlias,
      'bankCharge': bankCharge,
      'payTypeCode': payTypeCode,
      'description': description,
      'amount': amount,
      'subType': subType,
    };
  }

  factory MopSelectionEntity.fromMap(Map<String, dynamic> map) {
    return MopSelectionEntity(
      tpmt3Id: map['tpmt3Id'] as String,
      tpmt1Id: map['tpmt1Id'] as String,
      mopAlias: map['mopAlias'] as String,
      bankCharge:
          map['bankCharge'] != null ? map['bankCharge'] as double : null,
      payTypeCode:
          map['payTypeCode'] != null ? map['payTypeCode'] as String : null,
      description: map['description'] as String,
      amount: map['amount'] != null ? map['amount'] as double : null,
      subType: map['subType'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MopSelectionEntity.fromJson(String source) =>
      MopSelectionEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MopSelectionEntity(tpmt3Id: $tpmt3Id, tpmt1Id: $tpmt1Id, mopAlias: $mopAlias, bankCharge: $bankCharge, payTypeCode: $payTypeCode, description: $description, amount: $amount, subType: $subType)';
  }

  @override
  bool operator ==(covariant MopSelectionEntity other) {
    if (identical(this, other)) return true;

    return other.tpmt3Id == tpmt3Id &&
        other.tpmt1Id == tpmt1Id &&
        other.mopAlias == mopAlias &&
        other.bankCharge == bankCharge &&
        other.payTypeCode == payTypeCode &&
        other.description == description &&
        other.amount == amount &&
        other.subType == subType;
  }

  @override
  int get hashCode {
    return tpmt3Id.hashCode ^
        tpmt1Id.hashCode ^
        mopAlias.hashCode ^
        bankCharge.hashCode ^
        payTypeCode.hashCode ^
        description.hashCode ^
        amount.hashCode ^
        subType.hashCode;
  }
}
